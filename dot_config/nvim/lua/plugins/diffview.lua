return {
	"sindrets/diffview.nvim",
	keys = {
		{
			"<Leader>gD",
			mode = { "n" },
			"<CMD>DiffviewOpen<CR>",
			desc = "Diff Repo",
		},
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
	-- init = function()
	-- 	local map = require("stuff.functions").map
	-- 	map("n", "<Leader>gh", "<CMD>DiffviewFileHistory %<CR>", { desc = "File revision history" })
	-- 	map("n", "<Leader>gH", "<CMD>DiffviewFileHistory<CR>", { desc = "Repo revision history" })
	-- 	map("n", "<Leader>gD", "<CMD>DiffviewOpen<CR>", { desc = "Diff Repo" })
	-- end,
}
