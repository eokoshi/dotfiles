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
				highlight_inactive_windows = true,
			},
		},
	},
	{
		"sainnhe/everforest",
		lazy = true,
	},
	{ "luisiacc/gruvbox-baby",    lazy = true },
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{
		"folke/tokyonight.nvim",
		lazy = false,
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
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		---@type CatppuccinOptions
		opts = {
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				dap = true,
				dap_ui = true,
				gitsigns = true,
				illuminate = true,
				indent_blankline = true,
				markdown = true,
				mason = true,
				native_lsp = { enabled = true },
				neotree = true,
				notify = true,
				semantic_tokens = true,
				symbols_outline = true,
				telescope = true,
				treesitter = true,
				ts_rainbow = false,
				ufo = true,
				which_key = true,
				window_picker = true,
				colorful_winsep = { enabled = true, color = "lavender" },
			},
		},
		specs = {
			{
				"akinsho/bufferline.nvim",
				optional = true,
				opts = function(_, opts)
					return require("astrocore").extend_tbl(opts, {
						highlights = require("catppuccin.groups.integrations.bufferline").get(),
					})
				end,
			},
			{
				"nvim-telescope/telescope.nvim",
				optional = true,
				opts = {
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					},
				},
			},
		},
	},
}
