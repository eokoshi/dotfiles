-- Python keymaps
local map = require("stuff.functions").map
map("n", "<Leader>fi", "?import<CR>", { desc = "Jump to imports", buffer = true })
map(
	"v",
	"gd",
	":norm ysaw'f=r:A,<CR>gv<Plug>(nvim-surround-visual-line)}iargs = <ESC>va{o^",
	{ desc = "Convert lines to dict", buffer = true }
)
local api = vim.api
local fn = vim.fn

local function get_cursor_row()
	return api.nvim_win_get_cursor(0)[1] - 1
end

local function get_line(row)
	return api.nvim_buf_get_lines(0, row, row + 1, false)[1]
end

local function is_marker(row)
	local line = get_line(row)
	return line and line:match("^# %%%%")
end

local function find_cell_start()
	local row = get_cursor_row()

	while row >= 0 do
		if is_marker(row) then
			return row
		end
		row = row - 1
	end

	return 0
end

local function find_cell_end(start_row)
	local last = api.nvim_buf_line_count(0) - 1
	local row = start_row + 1

	while row <= last do
		if is_marker(row) then
			return row - 1
		end
		row = row + 1
	end

	return last
end

local function select_range(start_row, end_row)
	fn.setpos("'<", { 0, start_row + 1, 1, 0 })
	fn.setpos("'>", { 0, end_row + 1, 1, 0 })
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

	if start_row <= end_row then
		select_range(start_row, end_row)
	end
end

map("o", "aj", select_outer, { buffer = true, desc = "cell" })
map("x", "aj", select_outer, { buffer = true, desc = "cell" })

map("o", "ij", select_inner, { buffer = true, desc = "cell" })
map("x", "ij", select_inner, { buffer = true, desc = "cell" })
map("n", "]j", function()
	vim.fn.search("^# %%", "W")
end, { buffer = true, desc = "cell" })

map("n", "[j", function()
	vim.fn.search("^# %%", "bW")
end, { buffer = true, desc = "cell" })
