local map = require("functions").map
local gh = require("functions").gh
vim.g.mapleader = " "

vim.cmd.packadd("nvim.undotree")
vim.pack.add({
	{ src = gh("MagicDuck/grug-far.nvim") },
	{ src = gh("folke/flash.nvim") },
	{ src = gh("kylechui/nvim-surround") },
	{ src = gh("nvim-mini/mini.align") },
	{ src = gh("nvim-mini/mini.bracketed") },
	{ src = gh("windwp/nvim-autopairs") },
})

require("grug-far").setup()
require("nvim-autopairs").setup({})
require("mini.align").setup({})
require("mini.bracketed").setup({
	comment = { suffix = "#" },
	file = { suffix = "e" },
	indent = { suffix = "h" },
})
require("flash").setup({
	modes = { char = { enabled = false, autohide = true } },
	label = { rainbow = { enabled = true, shade = 6 } },
	prompt = { enabled = false },
})
local flash = require("flash")
map({ "n", "x", "o" }, "+", function() flash.jump() end, { desc = "Flash Jump" })
map({ "n", "x", "o" }, "-", function() flash.treesitter() end, { desc = "Flash Treesitter" })
map("o", "r", function() flash.remote() end, { desc = "Flash Remote" })

require("options")
vim.cmd("set statusline&")

local function vscode_call(cmd)
	return function() require("vscode").call(cmd) end
end
map("n", "]b", vscode_call("workbench.action.nextEditor"), { desc = "next editor" })
map("n", "[b", vscode_call("workbench.action.previousEditor"), { desc = "prev editor" })
map("n", "<leader>bc", vscode_call("workbench.action.closeActiveEditor"), { desc = "close active editor" })
map("n", "<leader>w", vscode_call("workbench.action.files.save"), { desc = "save" })
map("n", "ff", vscode_call("workbench.action.quickOpen"), { desc = "find files" })
map("n", "<leader>q", vscode_call("workbench.action.closeEditorsInGroup"), { desc = "close editor group" })
map("n", "<C-h>", vscode_call("workbench.action.navigateLeft"), { desc = "move left" })
map("n", "<C-l>", vscode_call("workbench.action.navigateRight"), { desc = "move right" })
map("n", "<BS>", vscode_call("workbench.action.navigateBack"), { desc = "go to alt file" })
map("n", "<leader>e", vscode_call("workbench.action.toggleSidebarVisibility"), { desc = "toggle sidebar" })
