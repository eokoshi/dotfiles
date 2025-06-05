vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")
require("config.options")
require("config.mappings")
require("config.autocmds")
require("config.highlights")

if vim.g.neovide then
	-- Put anything you want to happen only in Neovide here
	require("config.neovide")
end

require("config.final")
