local function map(mode, lhs, rhs, opts)
	-- set default value if not specify
	if opts.noremap == nil then
		opts.noremap = true
	end
	if opts.silent == nil then
		opts.silent = true
	end

	vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- system clipboard
map({ "n", "v" }, "<A-S-V>", "<C-v>", { desc = "Visual block mode" })
map({ "n" }, "<C-c>", '"+yy', { desc = "Copy line to system clipboard" })
map({ "v" }, "<C-c>", '"+y', { desc = "Copy selection to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste system clipboard" })
map({ "i", "c" }, "<C-v>", '<ESC>"+pa', { desc = "Paste system clipboard" })
map("n", "<C-a>", "<Cmd>%y+<CR><CR>", { desc = "Copy whole file to clipboard" })

-- center line on jump
map("n", "<C-u>", "<C-u>zz", { desc = "Jump up half page" })
map("n", "<C-d>", "<C-d>zz", { desc = "Jump down half page" })
map("n", "<C-o>", "<C-o>zz", { desc = "Jump to previous location" })
map("n", "<C-i>", "<C-i>zz", { desc = "Jump to next location" })
map("n", "n", "nzzzv", { desc = "Jump to next search result" })
map("n", "N", "Nzzzv", { desc = "Jump to previous search result" })

-- move windows with ctrl
map("n", "<C-h>", "<C-w>h", { desc = "Move to window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to window above" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to window below" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to window right" })

-- Basic operations
map("n", "<Leader>w", "<Cmd>w<CR>", { desc = "Save buffer" })
map("n", "<Leader>q", "<Cmd>q<CR>", { desc = "Quit window" })

-- Motions
map({ "i", "c" }, "<C-l>", "<C-o>a", { desc = "Move one char right" })
map({ "i", "c" }, "<C-h>", "<C-o>h", { desc = "Move one char left" })
map("n", "J", "mzJ`z", { desc = "Shift J without moving cursor", noremap = false })

-- Terminal
map("n", "<Leader>t<CR>", "<Cmd>ToggleTermSendCurrentLine<CR>", { desc = "Send current line to terminal" })
map("v", "<Leader>t<CR>", "<Cmd>ToggleTermSendVisualSelection<CR>", { desc = "Send visual selection to terminal" })
map("n", "<Leader>ts", "<Cmd>TermSelect<CR>", { desc = "Terminal picker" })
map("n", "<Leader>tb", "Vgg<Cmd>ToggleTermSendVisualSelection<CR><C-o>", { desc = "Send file up to this line to terminal" })
map("n", "<Leader>tv", "<Cmd>ToggleTerm size=20 direction=horizontal<CR>", { desc = "ToggleTerm vertical" })
map("n", "<Leader>th", "<Cmd>ToggleTerm size=80 direction=vertical<CR>", { desc = "ToggleTerm vertical" })

-- Diff
map({ "n", "v" }, "<Leader>dfo", "<Cmd>diffget<CR>", { desc = "Get the text from the other buffer to this one" })
map({ "n", "v" }, "<Leader>dfp", "<Cmd>diffput<CR>", { desc = "Put the text from this buffer to the other" })

-- Debugger
map("n", "<Leader>dl", "<Cmd>e .vscode/launch.json<CR>", { desc = "Open workspace debugger config" })

-- Random
map("n", "<Leader>fi", "/import<CR>N", { desc = "Jump to imports" })
map("n", "<Leader>fx", "<Cmd>cd %:h<CR>", { desc = "cd to current file's directory" })

map("n", "<Leader>m", "", { desc = "Markdown tools" })
map("n", "<Leader>mm", "<Cmd>lua require('nabla').popup({border = 'solid'})<CR>", { desc = "Show math popup" })
map("n", "<Leader>um", "<Cmd>lua require('nabla').toggle_virt({autogen = true, silent = true})<CR>", { desc = "Toggle math virtual text" })

vim.keymap.del("i", "<Tab>")
