-- Options
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2

-- Markdown keymaps
local map = require("stuff.functions").map
local toggles = require("stuff.toggles")
map("n", "<Leader>m", "", { desc = "Markdown", buffer = true })
map("n", "<Leader>mm", "<CMD>lua require('nabla').popup({border = 'solid'})<CR>", { desc = "Show math popup", buffer = true })
toggles.math_virt():map("<Leader>um")
