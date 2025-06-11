vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.g.neovide then
	-- Put anything you want to happen only in Neovide here
	require("config.neovide")
end

require("config.lazy")

vim.cmd.colorscheme("gruvbox-material")

require("config.options")
require("config.autocmds")
require("config.mappings")
require("config.highlights")
require("config.final")
