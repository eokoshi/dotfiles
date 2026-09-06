vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4

vim.b.default_repl = "ipython"
local is_django = vim.fs.root(0, "manage.py") ~= nil
if is_django then vim.b.default_repl = "python manage.py shell" end

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
	end

	-- py:percent {{{
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
	--- }}}

	-- Builtin :terminal python runner {{{
	vim.b.python_term = vim.b.python_term or { buf = nil, chan = nil, cmd = nil }
	local function term_is_running(chan) return type(chan) == "number" and chan > 0 and vim.fn.jobwait({ chan }, 0)[1] == -1 end
	local function is_floating(win) return vim.api.nvim_win_get_config(win).relative ~= "" end
	local function open_python_term(buf)
		local orig_win = vim.api.nvim_get_current_win()
		local curpos = vim.api.nvim_win_get_cursor(orig_win)
		local win = 0
		if is_floating(orig_win) then
			local cfg = vim.api.nvim_win_get_config(orig_win)
			local height = math.floor(vim.o.lines * 0.9 / 2)
			win = vim.api.nvim_open_win(buf, false, {
				relative = "win",
				row = height + 1,
				col = -1,
				width = cfg.width,
				height = height,
				style = "minimal",
			})
			vim.wo[win].winhighlight = "NormalFloat:Normal,FloatBorder:Green"
			vim.api.nvim_win_set_config(orig_win, {
				relative = "editor",
				col = cfg.col,
				row = 2,
				height = height,
			})
			vim.api.nvim_create_autocmd("WinClosed", {
				pattern = tostring(orig_win),
				once = true,
				callback = function()
					local t_term = vim.b[bufnr].python_term
					if t_term and t_term.buf and vim.api.nvim_buf_is_valid(t_term.buf) then
						local t_win = vim.fn.bufwinid(t_term.buf)
						if t_win ~= -1 then vim.api.nvim_win_close(t_win, true) end
					end
				end,
			})
		else
			local split_dir = (vim.o.columns > 240) and "right" or "below"
			win = vim.api.nvim_open_win(buf, false, {
				split = split_dir,
				style = "minimal",
			})
		end
		vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
		vim.api.nvim_win_set_cursor(orig_win, { curpos[1], 0 })
	end

	local function start_python_term(command)
		if not command or command == "" then return end
		if vim.b.python_term.buf and vim.api.nvim_buf_is_valid(vim.b.python_term.buf) then
			vim.api.nvim_buf_delete(vim.b.python_term.buf, { force = true })
		end
		local buf = vim.api.nvim_create_buf(false, true)
		open_python_term(buf)
		local chan = vim.api.nvim_buf_call(buf, function() return vim.fn.jobstart(command, { term = true }) end)

		local _started, errormsg = vim.wait(5000, function()
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			for i = #lines, 1, -1 do
				if lines[i]:match("command not found") or lines[i]:match("is not recognized") then return true, "Command not found: " .. command end
				if lines[i]:match("Traceback") then return true, table.concat(lines, "\n") end
				if lines[i]:match("^Python") or lines[i]:match("In %[%d+ %]:") then return true, "" end
			end
		end, 50)

		if errormsg ~= "" then
			if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
			vim.notify(errormsg, vim.log.levels.ERROR)
			return
		end

		vim.b.python_term = { buf = buf, chan = chan, cmd = command }
		return chan
	end

	local function ensure_python_term()
		if vim.b.python_term.buf and vim.api.nvim_buf_is_valid(vim.b.python_term.buf) and term_is_running(vim.b.python_term.chan) then
			local win = vim.fn.bufwinid(vim.b.python_term.buf)
			if win == -1 then open_python_term(vim.b.python_term.buf) end
			return vim.b.python_term.chan
		end
		local command = vim.fn.input("Enter CLI command to start REPL: ", vim.b.default_repl)
		return start_python_term(command)
	end

	---Normalize pasted Python so multi-block code executes correctly.
	--- taken from pyrepl.nvim 9ba320a
	---@param msg string
	---@return string
	local function normalize_python_message(msg)
		local lines = vim.split(msg, "\n", { plain = true, trimempty = false })
		if #lines <= 1 then return msg end

		local ok_parser, parser = pcall(vim.treesitter.get_string_parser, msg, "python")
		if not ok_parser or not parser then return msg end

		local tree = parser:parse()[1]
		if not tree then return msg end

		local root = tree:root()
		local top_nodes = {}
		for node in root:iter_children() do
			if node:named() and node:type() ~= "ERROR" then table.insert(top_nodes, node) end
		end
		if #top_nodes == 0 then return msg end

		---@return integer
		local function node_last_row(node)
			local _, _, end_row, end_col = node:range()
			if end_col == 0 then return math.max(end_row - 1, 0) end
			return end_row
		end

		---@param line string|nil
		---@return boolean
		local function is_blank_line(line) return (line and line:match("^%s*$")) ~= nil end

		---@param last_row integer
		---@param next_start integer
		---@return boolean
		local function has_blank_line_between(last_row, next_start)
			for row = last_row + 1, next_start - 1 do
				local line = lines[row + 1]
				if is_blank_line(line) then return true end
			end
			return false
		end
		local compound_top_level_nodes = {
			async_for_statement = true,
			async_function_definition = true,
			async_with_statement = true,
			class_definition = true,
			decorated_definition = true,
			for_statement = true,
			function_definition = true,
			if_statement = true,
			match_statement = true,
			try_statement = true,
			while_statement = true,
			with_statement = true,
		}

		local insert_after = {}
		local has_compound = false
		for idx, node in ipairs(top_nodes) do
			if compound_top_level_nodes[node:type()] then
				has_compound = true

				local last_row = node_last_row(node)
				local next_node = top_nodes[idx + 1]
				local next_start = next_node and select(1, next_node:range()) or #lines

				if next_start > last_row and not has_blank_line_between(last_row, next_start) then insert_after[last_row + 1] = true end
			end
		end

		if has_compound and not is_blank_line(lines[#lines]) then insert_after[#lines] = true end

		if next(insert_after) == nil then return msg end

		local out = {}
		for i, line in ipairs(lines) do
			table.insert(out, line)
			if insert_after[i] then table.insert(out, "") end
		end

		return table.concat(out, "\n")
	end

	---Send code to the REPL using bracketed paste.
	---@param chan integer
	---@param message string
	local function raw_send_message(chan, message)
		if message == "" then return end
		local prefix = vim.api.nvim_replace_termcodes("<esc>[200~", true, false, true)
		local suffix = vim.api.nvim_replace_termcodes("<esc>[201~", true, false, true)
		local normalized = normalize_python_message(message)
		vim.api.nvim_chan_send(chan, prefix .. normalized .. suffix .. "\n")
	end

	local function send_to_python_term()
		local chan = ensure_python_term()
		if chan == nil then return end
		local mode = vim.api.nvim_get_mode().mode
		local lines
		if mode:sub(1, 1):lower() == "v" or mode == "\22" then
			lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })
			vim.api.nvim_feedkeys(vim.keycode("<ESC>"), "n", false)
		else
			lines = { vim.api.nvim_get_current_line() }
		end

		local text = table.concat(lines, "\n")
		if text ~= "" then
			raw_send_message(chan, text)
			local term_buf = vim.b.python_term.buf
			if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
				local win = vim.fn.bufwinid(term_buf)
				if win ~= -1 then
					local line_count = vim.api.nvim_buf_line_count(term_buf)
					vim.api.nvim_win_set_cursor(win, { line_count, 0 })
				end
			end
		end
	end

	map({ "n", "x" }, "<CR>", send_to_python_term, { desc = "Send to REPL", buffer = true })
	map("n", "<leader>bx", function()
		if vim.b.python_term.buf ~= nil then vim.api.nvim_buf_delete(vim.b.python_term.buf, { force = true }) end
	end, { desc = "Close REPL", buffer = true })
	--- }}}
end
