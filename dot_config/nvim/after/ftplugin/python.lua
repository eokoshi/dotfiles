vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4

local map = require("functions").map
local bufnr = vim.api.nvim_get_current_buf()
if vim.bo[bufnr].buftype == "" then
	local firstline = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]

	-- commands
	local args = { "pd", "np", "plt", "pl" }
	local outputs = {
		pd = "import pandas as pd",
		np = "import numpy as np",
		plt = "import matplotlib.pyplot as plt",
		pl = "import polars as pl",
	}
	vim.api.nvim_buf_create_user_command(0, "Import", function(data)
		local function put_line(import_line)
			local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
			local lines = vim.api.nvim_buf_get_lines(0, 0, cursor_line, false)
			local target_row = cursor_line
			local indent = ""
			for i = cursor_line, 1, -1 do
				local line = lines[i] or ""
				if line:match("^%s*import%s+") or line:match("^%s*from%s+.-%s+import%s+") then
					target_row = i
					indent = line:match("^(%s*)") or ""
					break
				end
			end
			if target_row == cursor_line then
				target_row = 0
				indent = ""
			end
			import_line = indent .. import_line
			vim.schedule(function() vim.api.nvim_buf_set_lines(0, target_row, target_row, false, { import_line }) end)
		end

		if #data.fargs == 0 then
			vim.ui.select(args, { prompt = "Select shorthand import" }, function(item, _idx) put_line(outputs[item]) end)
		else
			put_line(outputs[data.fargs[1]])
		end
	end, { nargs = "*", complete = function(lead, cmdline, cursorpos) return args end })

	-- keymaps
	map("v", "gd", ":norm ysaw'f=r:A,<CR>gv<Plug>(nvim-surround-visual-line)}iargs = <ESC>va{o^", { desc = "Convert lines to dict", buffer = true })

	-- notebooks
	-- MARIMO
	if firstline == "import marimo" then
		if not vim.b.marimo then
			vim.b.marimo = true
			vim.api.nvim_echo({ { "Detected marimo notebook in buf " .. bufnr, "Red" } }, false, {})
		end
		-- import relocation inside cell
		if not vim.b.marimo_import_relocator then
			vim.b.marimo_import_relocator = true
			vim.api.nvim_buf_attach(bufnr, false, {
				on_lines = function(_, _, _, startline, _, new_lastline)
					if startline > 0 or new_lastline < 0 then return end

					local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
					if first_line == "import marimo" then return end
					if not first_line:match("^import ") and not first_line:match("^from .* import ") then return end

					local cursor = vim.api.nvim_win_get_cursor(0)
					local current_row = cursor[1]

					local cell_start_row = nil
					for i = current_row, 1, -1 do
						local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1] or ""
						if line:match("^@app%.cell") then
							cell_start_row = i
							break
						end
					end

					if cell_start_row then
						vim.schedule(function()
							if not vim.api.nvim_buf_is_valid(bufnr) then return end
							local current_first = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
							if current_first ~= first_line then return end

							vim.api.nvim_buf_set_lines(0, 0, 1, false, {})
							vim.api.nvim_buf_set_lines(0, cell_start_row, cell_start_row, false, { "    " .. first_line })

						end)
					end
				end,
				on_detach = function() vim.b.marimo_import_relocator = nil end,
				on_reload = function() vim.b.marimo_import_relocator = nil end,
			})
		end

	-- py:percent
	elseif firstline and string.match(firstline, "^# %%%%") ~= nil then
		local function get_cursor_row() return vim.api.nvim_win_get_cursor(0)[1] - 1 end
		local function get_line(row) return vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] end
		local function is_marker(row)
			local line = get_line(row)
			return line and line:match("^# %%%%")
		end
		local function find_cell_start()
			local row = get_cursor_row()
			while row >= 0 do
				if is_marker(row) then return row end
				row = row - 1
			end
			return 0
		end
		local function find_cell_end(start_row)
			local last = vim.api.nvim_buf_line_count(0) - 1
			local row = start_row + 1
			while row <= last do
				if is_marker(row) then return row - 1 end
				row = row + 1
			end
			return last
		end

		local function select_range(start_row, end_row)
			vim.fn.setpos("'<", { 0, start_row + 1, 1, 0 })
			vim.fn.setpos("'>", { 0, end_row + 1, 1, 0 })
			vim.cmd("normal! gvV")
		end

		local function select_outer()
			local start_row = find_cell_start()
			local end_row = find_cell_end(start_row)
			select_range(start_row, end_row)
		end

		local function select_inner()
			local start_row = find_cell_start() + 1
			local end_row = find_cell_end(start_row - 1)

			if start_row <= end_row then select_range(start_row, end_row) end
		end

		map("o", "aj", select_outer, { buffer = true, desc = "cell" })
		map("x", "aj", select_outer, { buffer = true, desc = "cell" })
		map("o", "ij", select_inner, { buffer = true, desc = "cell" })
		map("x", "ij", select_inner, { buffer = true, desc = "cell" })
		map("n", "]j", function() vim.fn.search("^# %%", "W") end, { buffer = true, desc = "cell" })
		map("n", "[j", function() vim.fn.search("^# %%", "bW") end, { buffer = true, desc = "cell" })
	end

	-- Builtin :terminal python runner
	local python_term = { buf = nil, chan = nil }
	local function python_term_running(chan)
		if type(chan) ~= "number" or chan <= 0 then return false end
		return vim.fn.jobwait({ chan }, 0)[1] == -1
	end

	local function open_python_term(command)
		if not command or command == "" then return end
		local orig_win = vim.api.nvim_get_current_win()
		if python_term.buf and vim.api.nvim_buf_is_valid(python_term.buf) then
			local old_win = vim.fn.bufwinid(python_term.buf)
			if old_win ~= -1 then vim.api.nvim_win_close(old_win, true) end
			vim.api.nvim_buf_delete(python_term.buf, { force = true })
		end
		local buf = vim.api.nvim_create_buf(false, true)
		vim.b[buf].ipython_term = true
		local split = (vim.o.columns > 160) and "right" or "below"
		local win = vim.api.nvim_open_win(buf, false, {
			split = split,
			style = "minimal",
		})
		vim.api.nvim_set_current_win(win)
		local chan = vim.fn.jobstart(command, { term = true })
		python_term = { buf = buf, chan = chan }
		vim.api.nvim_set_current_win(orig_win)
		if chan <= 0 then return chan end
		return chan
	end

	local function ensure_python_term()
		if python_term.buf and vim.api.nvim_buf_is_valid(python_term.buf) and python_term_running(python_term.chan) then
			if vim.fn.bufwinid(python_term.buf) == -1 then
				local orig_win = vim.api.nvim_get_current_win()
				local cmd = (vim.o.columns > vim.o.lines) and "vsplit" or "split"
				vim.cmd(cmd)
				vim.api.nvim_win_set_buf(0, python_term.buf)
				vim.api.nvim_set_current_win(orig_win)
			end
			return python_term.chan
		end
		local command = vim.fn.input("enter cli command to start REPL: ", "ipython")
		if command == "" then return nil end
		return open_python_term(command)
	end

	local function send_to_python_term()
		local chan = ensure_python_term()
		if not python_term_running(chan) then
			vim.notify("python terminal is not running", vim.log.levels.WARN)
			return
		end
		local mode = vim.api.nvim_get_mode().mode
		if mode:sub(1, 1) == "v" or mode == "\22" then
			vim.cmd('normal! "yy')
		else
			vim.cmd('normal! "yyy')
		end
		local text = vim.fn.getreg('"')
		if text and #text > 0 then
			text = text:gsub("\t", "    ")
			text = text:gsub("%s+$", "")
			if text ~= "" then
				text = text .. "\n"
				-- Bracketed paste keeps multi-line selections as one ipython input; the trailing Enter executes it.
				vim.fn.chansend(chan, "\27[200~" .. text .. "\27[201~" .. "\n")
			end
		end
	end

	map({ "n", "x" }, "<CR>", send_to_python_term, { desc = "Send selection/line to ipython terminal", buffer = true })
end
