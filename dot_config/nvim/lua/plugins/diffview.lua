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
				{ "n", "<Leader>q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
				{ "n", "<Leader>c", "", { desc = "Conflicts" } },
			},
			file_panel = {
				{ "n", "<Leader>q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
			},
		},
	},
	init = function()
		require("stuff.functions").map("n", "<Leader>gh", "<CMD>DiffviewFileHistory<CR>", { desc = "File History" })
	end,
}
