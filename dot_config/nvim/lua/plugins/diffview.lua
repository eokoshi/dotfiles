return {
	"sindrets/diffview.nvim",
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
	init = function()
		require("stuff.functions").map("n", "<Leader>gh", "<CMD>DiffviewFileHistory %<CR>", { desc = "File revision history" })
		require("stuff.functions").map("n", "<Leader>gH", "<CMD>DiffviewFileHistory<CR>", { desc = "Repo revision history" })
		require("stuff.functions").map("n", "<Leader>gD", "<CMD>DiffviewOpen<CR>", { desc = "Diff Repo" })
	end,
}
