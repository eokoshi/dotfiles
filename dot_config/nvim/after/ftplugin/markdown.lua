-- Options
vim.opt_local.wrap = true
vim.opt_local.breakindent = true
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2

-- Markdown keymaps
local toggles = require("stuff.toggles")
local map = require("stuff.functions").map
map("n", "<Leader>m", "", { desc = "Markdown", buffer = true })
map(
	"n",
	"<Leader>mm",
	"<CMD>lua require('nabla').popup({border = 'solid'})<CR>",
	{ desc = "Show math popup", buffer = true }
)
toggles.math_virt():map("<Leader>mv", { buffer = true })
