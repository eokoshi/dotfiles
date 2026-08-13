vim.g.mapleader = " "

-- require("lazy-init")

require("options")
require("autocmds")
require("mappings")
require("highlights")

vim.cmd.colorscheme("gruvbox-material")

if vim.fn.has("win32") == 1 then
	require("windows")
elseif vim.fn.environ()["TERM"] == "linux" then
	vim.cmd.colorscheme("default")
end

require("final")
