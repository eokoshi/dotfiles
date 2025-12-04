return {
	"sindrets/diffview.nvim",
	keys = {
		{ "<Leader>gD", mode = { "n" }, "<CMD>DiffviewOpen<CR>", desc = "Diff repo" },
		{ "<Leader>gh", mode = { "n" }, "<CMD>DiffviewFileHistory %<CR>", desc = "History: file" },
		{ "<Leader>gH", mode = { "n" }, "<CMD>DiffviewFileHistory<CR>", desc = "History: repo" },
	},
	opts = {
		view = {
			default = {
				disable_diagnostics = true,
				winbar_info = true,
			},
		},
		keymaps = {
			view = {
				{ "n", "<Leader>q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
				{ "n", "<Leader>c", "", { desc = "Conflicts" } },
			},
			file_panel = {
				{ "n", "<Leader>q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
			},
			file_history_panel = {
				{ "n", "<Leader>q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
			},
		},
		file_history_panel = {
			win_config = {
				position = "left",
				width = 35,
				win_opts = {},
			},
		},
	},
}
