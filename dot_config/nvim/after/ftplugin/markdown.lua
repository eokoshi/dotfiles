-- Options
vim.opt_local.wrap = true
vim.opt_local.expandtab = true
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.linebreak = true -- Wrap lines at convenient points
-- vim.opt_local.showbreak = "> "

local map = vim.keymap.set
map("n", "j", "gj", { buffer = true }) --- move by visual lines
map("n", "k", "gk", { buffer = true })
