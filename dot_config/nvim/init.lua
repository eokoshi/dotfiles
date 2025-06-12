vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

if vim.g.neovide then
	-- Put anything you want to happen only in Neovide here
	require("config.neovide")
end

require("config.options")
require("config.autocmds")
require("config.mappings")
require("config.lazy")
require("config.colors")
require("config.final")
