return {
	"dmtrKovalenko/fff.nvim",
	commit = "7fd361a",
	dependencies = {
		"saghen/blink.cmp",
	},
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
			normal = "NormalFloat",
			active_file = "ColorColumn",
			title = "FloatTitle",
		},
		debug = {
			enabled = false,
			show_scores = true,
		},
	},
	keys = {
		{
			"ff", -- try it if you didn't it is a banger keybinding for a picker
			function()
				require("fff").find_files()
			end,
			desc = "FFFind files",
		},
	},
}
