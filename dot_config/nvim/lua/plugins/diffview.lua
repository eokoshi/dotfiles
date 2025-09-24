return {
	"sindrets/diffview.nvim",
	opts = {
		view = {
			default = {
				disable_diagnostics = true,
			},
		},
		keymaps = {
			view = {
				{ "n", "<Leader>Q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
				{ "n", "<Leader>c", "", { desc = "Conflicts" } },
			},
			file_panel = {
				{ "n", "<Leader>Q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
			},
		},
	},
}
