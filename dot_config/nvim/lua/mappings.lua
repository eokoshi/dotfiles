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
map("i", "<S-Tab>", "<C-d>", { desc = "Unindent 1 level" })
map("n", "J", "mzJ`z", { desc = "Shift J without moving cursor", noremap = false })
map("n", "<BS>", "<C-^>", { desc = "Switch to prev file" })
map("n", "<leader>bt", "<CMD>tabclose<CR>", { desc = "Close tab" })

-- System clipboard
map({ "n" }, "<C-c>", '"+yy', { desc = "Copy line to system clipboard" })
map({ "v" }, "<C-c>", '"+y', { desc = "Copy selection to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste system clipboard" })
map({ "i", "c" }, "<C-v>", '<C-r>+', { desc = "Paste system clipboard" })

-- Movement
map("n", "<C-u>", "<C-u>zz", { desc = "Jump up half page" })
map("n", "<C-d>", "<C-d>zz", { desc = "Jump down half page" })
map("n", "<C-o>", "<C-o>zz", { desc = "Jump to previous location" })
map("n", "<C-i>", "<C-i>zz", { desc = "Jump to next location" })
map("n", "n", "nzzzv", { desc = "Jump to next search result" })
map("n", "N", "Nzzzv", { desc = "Jump to previous search result" })
map("n", "<C-UP>", "<C-y>", { desc = "Scroll up" })
map("n", "<C-DOWN>", "<C-e>", { desc = "Scroll down" })
map("n", "<C-h>", "<C-w>h", { desc = "Move to window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to window above" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to window below" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to window right" })

-- Buffers
map("n", "<Leader>bA", "<CMD>%y+<CR><CR>", { desc = "Copy whole buffer to clipboard" })
map("n", "<Leader>bD", function() functions.DOS_to_Unix() end, { desc = "DOS to Unix" })
map("n", "<Leader>bf", function() vim.lsp.buf.format() end, { desc = "format buffer" })

-- LSP
map("n", "<Leader>la", function() vim.lsp.buf.code_action() end, { desc = "code actions" })
map("n", "<Leader>ld", function() vim.diagnostic.open_float() end, { desc = "show diagnostic" })
map("n", "<Leader>lc", function() vim.diagnostic.setqflist() end, { desc = "qflist diagnostics" })
map("n", "<Leader>lr", function() vim.lsp.buf.rename() end, { desc = "rename symbol" })
map("n", "<Leader>lw", function() vim.lsp.buf.workspace_diagnostics() end, { desc = "workspace diagnostics" })
map("n", "<Leader>li", "<CMD>checkhealth vim.lsp<CR>", { desc = "LSP info" })
map("n", "gco", "o<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment below" })
map("n", "gcO", "O<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment above" })
