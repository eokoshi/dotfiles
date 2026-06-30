vim.opt_local.signcolumn = "no"
vim.opt_local.statuscolumn = ""
vim.opt_local.foldcolumn = "0"
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.colorcolumn = "0"

local bufnr = vim.api.nvim_get_current_buf()
vim.b[bufnr].snacks_indent = false
