vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.autocmds")
require("config.lazy")
require("config.mappings")
require("config.highlights")
require("config.final")

if vim.fn.has("win32") == 1 then
	vim.cmd.colorscheme("onelight")
	require("config.neovide")
else
	vim.cmd.colorscheme("gruvbox-material")
end
