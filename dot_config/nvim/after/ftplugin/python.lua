vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4

-- Python keymaps
local map = require("stuff.functions").map
map("v", "gd", ":norm ysaw'f=r:A,<CR>gv<Plug>(nvim-surround-visual-line)}iargs = <ESC>va{o^", { desc = "Convert lines to dict", buffer = true })

-- notebooks
local firstline = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
if not firstline then return end

-- MARIMO
if firstline == "import marimo" then
	-- import relocation inside cell
	if not vim.b.marimo_import_relocator then
		vim.notify("Detected marimo notebook", vim.log.levels.INFO)
		vim.b.marimo_import_relocator = true
		local bufnr = vim.api.nvim_get_current_buf()
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
						cell_start_row = i + 1
						break
					end
				end

				if cell_start_row then
					vim.schedule(function()
						if not vim.api.nvim_buf_is_valid(bufnr) then return end
						local current_first = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
						if current_first ~= first_line then return end

						vim.api.nvim_buf_set_lines(0, 0, 1, false, {})
						vim.api.nvim_buf_set_lines(0, cell_start_row - 1, cell_start_row - 1, false, { "    " .. first_line })

					end)
				end
			end,
		})
	end

	-- py:percent
elseif string.match(firstline, "^# %%%%") ~= nil then
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
