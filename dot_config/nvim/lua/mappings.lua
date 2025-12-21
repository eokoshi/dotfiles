local functions = require("stuff.functions")
local map = functions.map

-- stylua: ignore start
-- Basic operations
map("n", "<Leader>q", "<CMD>q<CR>", { desc = "Quit window" })
map("n", "<Leader>Q", "<CMD>qa<CR>", { desc = "Quit nvim" })
map("n", "<Leader>w", "<CMD>w<CR>", { desc = "Save buffer" })
map("n", "<Leader>.", "<CMD>cd %:h<CR>", { desc = "cd here" })
map("n", "<Leader><space>", "<ESC>", { desc = "" })
map({ "n", "v" }, "c", "\"ac", { desc = "Change" }) -- do not yank text on change
map("t", "<ESC>", "<C-\\><C-n>", {desc="Escape terminal mode"})

-- System clipboard
map({ "n", "v" }, "<C-q>", "<C-q>", { desc = "Visual block mode" })
map({ "n" }, "<C-c>", '"+yy', { desc = "Copy line to system clipboard" })
map({ "v" }, "<C-c>", '"+y', { desc = "Copy selection to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste system clipboard" })
map({ "i", "c" }, "<C-v>", '<ESC>"+pa', { desc = "Paste system clipboard" })

-- Movement
map("n", "<C-u>", "<C-u>zz", { desc = "Jump up half page" })
map("n", "<C-d>", "<C-d>zz", { desc = "Jump down half page" })
map("n", "<C-o>", "<C-o>zz", { desc = "Jump to previous location" })
map("n", "<C-i>", "<C-i>zz", { desc = "Jump to next location" })
map("n", "n", "nzzzv", { desc = "Jump to next search result" })
map("n", "N", "Nzzzv", { desc = "Jump to previous search result" })
map("n", "<C-h>", "<C-w>h", { desc = "Move to window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to window above" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to window below" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to window right" })
map({ "i", "c" }, "<C-l>", "<C-o>a", { desc = "Move one char right" })
map({ "i", "c" }, "<C-h>", "<C-o>h", { desc = "Move one char left" })
map("i", "<S-Tab>", "<C-d>", { desc = "Unindent 1 level" })
map("n", "J", "mzJ`z", { desc = "Shift J without moving cursor", noremap = false })
map("n", "<BS>", "<C-^>", { desc = "Switch to prev file" })

-- Buffers
map("n", "<Leader>bA", "<CMD>%y+<CR><CR>", { desc = "Copy whole buffer to clipboard" })
map("n", "<Leader>bd", "<CMD>bd<CR>", { desc = "Close buffer and window (:bd)" })
map("n", "<Leader>bD", function() functions.DOS_to_Unix() end, { desc = "DOS to Unix" })
map("n", "<Leader>bf", function() vim.lsp.buf.format() end, { desc = "format buffer" })
map("n", "<Leader>bC", function()
	local cur = vim.b.completion
	if cur == false then
		vim.b.completion = true
	else
		vim.b.completion = false
	end
end, { desc = "toggle completion" })


-- LSP
map({ "n", "x" }, "<Leader>la", function() vim.lsp.buf.code_action() end, { desc = "LSP code actions" })
map("n", "<Leader>ld", function() vim.diagnostic.open_float() end, { desc = "hover diagnostics" })
map("n", "<Leader>lf", function() vim.lsp.buf.format() end, { desc = "format buffer" })
map("n", "<Leader>lh", function() vim.lsp.buf.signature_help() end, { desc = "signature help" })
map("n", "<Leader>ll", function() vim.lsp.codelens.run() end, { desc = "codelens run" })
map("n", "<Leader>lL", function() vim.lsp.codelens.refresh() end, { desc = "codelens refresh" })
map("n", "<Leader>lr", function() vim.lsp.buf.rename() end, { desc = "rename symbol" })
map("n", "<Leader>li", "<CMD>LspInfo<CR>", { desc = "LSP info" })
map("n", "gco", "o<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment below" })
map("n", "gcO", "O<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment above" })


-- Package/Plugin Management
map("n", "<Leader>pi", "<CMD>Lazy<CR>", { desc = "Lazy" })
map("n", "<Leader>pm", "<CMD>Mason<CR>", { desc = "Mason" })
map("n", "<Leader>pa", function()
	vim.ui.input({ prompt = "Edit plugin spec" }, function(input)
		if input ~= nil then
			local file = vim.fn.stdpath("config") .. "/lua/plugins/" .. input .. ".lua"
			vim.notify("Editing " .. file, "info")
			vim.cmd("e " .. file)
		end
	end)
end, { desc = "add plugin" })

-- Blink completion
vim.keymap.del("i", "<Tab>")
