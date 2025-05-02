return {
	{
		"uloco/bluloco.nvim",
		lazy = true,
		dependencies = { "rktjmp/lush.nvim" },
		opts = {},
	},
	{
		"olimorris/onedarkpro.nvim",
		lazy = true,
		opts = {
			options = {
				cursorline = true,
				highlight_inactive_windows = true,
			},
		},
	},
	{
		"sainnhe/everforest",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.everforest_background = "hard"
			vim.g.everforest_better_performance = 1
			vim.g.everforest_enable_italic = 1
		end,
	},
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{
		"folke/tokyonight.nvim",
		lazy = true,
		priority = 1000,
		opts = {},
	},
	{
		"sainnhe/sonokai",
		lazy = true,
		dependencies = {
			"AstroNvim/astrocore",
			opts = {
				options = {
					g = {
						sonokai_dim_inactive_windows = 1,
					},
				},
			},
		},
	},
}
