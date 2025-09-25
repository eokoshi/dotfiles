return {
	"dmtrKovalenko/fff.nvim",
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	lazy = false,
	opts = {
		prompt = "❭ ",
		layout = {
			prompt_position = "top",
		},
		keymaps = {
			preview_scroll_up = "<C-p>",
			preview_scroll_down = "<C-n>",
		},
		hl = {
			active_file = "ColorColumn",
		},
		debug = {
			enabled = true, -- we expect your collaboration at least during the beta
			show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
		},
	},
}
