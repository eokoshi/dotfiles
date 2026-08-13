vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4

local map = require("stuff.functions").map
local bufnr = vim.api.nvim_get_current_buf()
if vim.bo[bufnr].buftype == "" then
	local firstline = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]

	-- commands
	vim.api.nvim_buf_create_user_command(0, "Importpd", function()
		local import_row = 0
		for i = 0, 50 do
			local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1] or ""
			if line:match("^import ") or line:match("^from .* import ") then
				import_row = i
				break
			elseif line:match("^__author__.*") then
				import_row = i - 1
				break
			end
		end
		vim.schedule(function() vim.api.nvim_buf_set_lines(0, import_row, import_row, false, { "import pandas as pd" }) end)
	end, {})

	vim.api.nvim_buf_create_user_command(0, "Importnp", function()
		local import_row = 0
		for i = 0, 50 do
			local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1] or ""
			if line:match("^import ") or line:match("^from .* import ") then
				import_row = i
				break
			elseif line:match("^__author__.*") then
				import_row = i - 1
				break
			end
		end
		vim.schedule(function() vim.api.nvim_buf_set_lines(0, import_row, import_row, false, { "import numpy as np" }) end)
	end, {})

	vim.api.nvim_buf_create_user_command(0, "Importplt", function()
		local import_row = 0
		for i = 0, 50 do
			local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1] or ""
			if line:match("^import ") or line:match("^from .* import ") then
				import_row = i
				break
			elseif line:match("^__author__.*") then
				import_row = i - 1
				break
			end
		end
		vim.schedule(function() vim.api.nvim_buf_set_lines(0, import_row, import_row, false, { "import matplotlib.pyplot as plt" }) end)
	end, {})

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

	-- Builtin :terminal ipython runner (no tmux needed)
	local ipython_term = { buf = nil, chan = nil }

	local function ipython_term_running(chan)
		if type(chan) ~= "number" or chan <= 0 then return false end
		return vim.fn.jobwait({ chan }, 0)[1] == -1
	end

	local function open_ipython_term()
		local orig_win = vim.api.nvim_get_current_win()
		local old_win = -1
		if ipython_term.buf and vim.api.nvim_buf_is_valid(ipython_term.buf) then old_win = vim.fn.bufwinid(ipython_term.buf) end
		if old_win ~= -1 then
			vim.api.nvim_set_current_win(old_win)
		else
			local cmd = (vim.o.columns < vim.o.lines) and "vsplit" or "split"
			vim.cmd(cmd)
		end
		vim.cmd("terminal ipython")
		local buf = vim.api.nvim_get_current_buf()
		local chan = vim.b[buf].terminal_job_id
		vim.b[buf].ipython_term = true
		vim.bo[buf].buflisted = false -- keep it out of ]b/[b buffer cycling
		vim.bo[buf].bufhidden = "hide"
		ipython_term = { buf = buf, chan = chan }
		vim.api.nvim_set_current_win(orig_win)

		-- Wait for the ipython prompt so the first send isn't echoed back as
		-- raw escape sequences.
		vim.wait(5000, function()
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			for i = #lines, 1, -1 do
				if lines[i]:match("^In %[%d+%]:") then return true end
			end
			return false
		end, 50)
		return chan
	end

	local function ensure_ipython_term()
		if ipython_term.buf and vim.api.nvim_buf_is_valid(ipython_term.buf) and ipython_term_running(ipython_term.chan) then
			if vim.fn.bufwinid(ipython_term.buf) == -1 then
				local orig_win = vim.api.nvim_get_current_win()
				local cmd = (vim.o.columns > vim.o.lines) and "vsplit" or "split"
				vim.cmd(cmd)
				vim.api.nvim_win_set_buf(0, ipython_term.buf)
				vim.api.nvim_set_current_win(orig_win)
			end
			return ipython_term.chan
		end
		return open_ipython_term()
	end

	local function send_to_ipython_term()
		local chan = ensure_ipython_term()
		if not ipython_term_running(chan) then
			vim.notify("ipython terminal is not running", vim.log.levels.WARN)
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
				-- Bracketed paste keeps multi-line selections as one ipython
				-- input; the trailing Enter executes it.
				vim.fn.chansend(chan, "\27[200~" .. text .. "\27[201~" .. "\n")
			end
		end
	end

	map({ "n", "x" }, "<CR>", send_to_ipython_term, { desc = "Send selection/line to ipython terminal", buffer = true })

	-- TMUX ipython
	local function run_tmux(args) return vim.fn.system(vim.list_extend({ "tmux" }, args)) end
	local function find_ipython_pane()
		local out = run_tmux({ "list-panes", "-F", "#{pane_id}\t#{pane_title}" })
		for line in out:gmatch("[^\n]+") do
			local pane_id, title = line:match("^(%%%d+)\t(.*)$")
			if title == "ipython" then return pane_id end
		end
		return nil
	end
	local function ensure_ipython_pane()
		local pane = find_ipython_pane()
		if pane then return pane end
		local width = tonumber(run_tmux({ "display-message", "-p", "#{pane_width}" }))
		local height = tonumber(run_tmux({ "display-message", "-p", "#{pane_height}" }))
		local split = (width and height and width < height) and "-h" or "-v"
		local current = vim.env.TMUX_PANE
		if not current or current == "" then current = run_tmux({ "display-message", "-p", "#{pane_id}" }):gsub("%s+", "") end
		local new_pane = run_tmux({ "split-window", "-d", split, "-t", current, "-P", "-F", "#{pane_id}", "ipython" }):gsub("%s+", "")
		if new_pane ~= "" then
			run_tmux({ "select-pane", "-T", "ipython", "-t", new_pane })
			return new_pane
		end
		return current
	end
	local function send_to_tmux()
		local target_pane = ensure_ipython_pane()
		local mode = vim.api.nvim_get_mode().mode
		if mode:sub(1, 1) == "v" or mode == "\22" then
			vim.cmd('normal! "yy')
		else
			vim.cmd('normal! "yyy')
		end
		local text = vim.fn.getreg('"')
		---@cast text string
		if text and #text > 0 then
			text = text:gsub("\t", "    ")
			text = text:gsub("%s+$", "")
			if text ~= "" then
				text = text .. "\n"
				run_tmux({ "set-buffer", "--", text })
				run_tmux({ "paste-buffer", "-dp", "-t", target_pane })
				run_tmux({ "send-keys", "-t", target_pane, "Enter" })
			end
		end
	end
	-- map({ "n", "x" }, "<CR>", send_to_tmux, { desc = "Send selection/line to ipython tmux pane", buffer=true })
end
