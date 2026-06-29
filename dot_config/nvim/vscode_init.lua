-- Set leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	spec = {
		{
			{
				"windwp/nvim-autopairs",
				event = "InsertEnter",
				opts = {},
			},

			{
				"kylechui/nvim-surround",
				opts = {},
			},

			{
				"nvim-mini/mini.align",
				opts = {},
			},
			{
				"nvimdev/hlsearch.nvim",
				opts = {},
			},
			{
				"nvim-lualine/lualine.nvim",
				opts = function()
					local macro = require("lualine.component"):extend()
					function macro:update_status()
						local reg = vim.fn.reg_recording()
						if reg == "" then return "" end
						return "recording @" .. reg .. " "
					end
					return {
						options = {
							theme = "auto",
							component_separators = " ",
							section_separators = { left = " ", right = " ⦙" },
							globalstatus = true,
						},
						sections = {
							lualine_a = { "mode" },
							lualine_b = {},
							lualine_c = {},
							lualine_x = {},
							lualine_y = { "location" },
							lualine_z = { macro },
						},
					}
				end,
			},
			{
				"folke/flash.nvim",
				event = "VeryLazy",
				opts = {
					modes = {
						char = {
							enabled = false,
							autohide = true,
						},
					},
					label = {
						rainbow = {
							enabled = true,
							shade = 6,
						},
					},
					prompt = {
						enabled = false,
					},
				},
				keys = {
					{
						"+",
						mode = { "n", "x", "o" },
						function() require("flash").jump() end,
						desc = "Flash",
					},
					{
						"H",
						mode = { "n", "x", "o" },
						function() require("flash").treesitter() end,
						desc = "Flash treesitter",
					},
					{
						"L",
						mode = { "n", "x", "o" },
						function() require("flash").treesitter_search() end,
						desc = "Flash treesitter search",
					},
					{
						"r",
						mode = "o",
						function() require("flash").remote() end,
						desc = "Remote Flash",
					},
				},
			},
		},
	},
	checker = { enabled = false },
	change_detection = { notify = false },
	ui = {
		title = " 󰒲 lazy.nvim ",
		size = { width = 0.8, height = 0.8 },
		border = "none",
		wrap = false,
		install = { colorscheme = { "wildcharm" } },
		icons = require("stuff.icons").lazy,
		style = "minimal",
	},
	git = { timeout = 30 },
	rocks = { enabled = false },
})
vim.keymap.set("n", "<Leader>pi", "<CMD>Lazy<CR>", { desc = "Lazy" })

require("options")

-- Helper function for VSCode commands
local function vscode_call(cmd)
	return function() require("vscode").call(cmd) end
end

-- Keybindings
local map = require("stuff.functions").map
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
