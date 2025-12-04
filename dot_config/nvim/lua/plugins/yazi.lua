return {
	"mikavilpas/yazi.nvim",
	version = "*", -- use the latest stable version
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	keys = {
		{ "<Leader>~", mode = { "n" }, "<CMD>Yazi cwd<CR>", desc = "yazi cwd" },
		{ "<Leader>fo", mode = { "n" }, "<CMD>Yazi<CR>", desc = "yazi current file" },
	},
	opts = {
		open_for_directories = true,
	},
	init = function()
		vim.g.loaded_netrwPlugin = 1
	end,
}
