--@type LazySpec
return {
	{
		"astronvim/astrotheme",
		lazy = true,
		opts = {},
	},
	{
		"ribru17/bamboo.nvim",
		lazy = true,
		opts = {},
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		opts = {},
	},
	{
		"olimorris/onedarkpro.nvim",
		lazy = true,
		opts = {
			styles = {
				comments = "italic",
				keywords = "bold, italic",
				conditionals = "italic",
				-- functions = "italic",
			},
			highlights = {
				NormalFloat = { link = "Normal" },
				FloatBorder = { link = "UltestBorder" },
			},
		},
	},
	{
		"sainnhe/everforest",
		lazy = true,
		config = function()
			vim.g.everforest_background = "medium"
			vim.g.everforest_better_performance = 1
			vim.g.everforest_enable_italic = 1
		end,
	},
	{
		"sainnhe/edge",
		lazy = true,
		config = function()
			vim.g.edge_style = "default"
			vim.g.edge_better_performance = 1
			vim.g.edge_enable_italic = 1
		end,
	},
	{
		"sainnhe/gruvbox-material",
		lazy = true,
		config = function()
			vim.g.gruvbox_material_foreground = "material"
			vim.g.gruvbox_material_background = "medium"
			vim.g.gruvbox_material_enable_italic = 1
			vim.g.gruvbox_material_enable_bold = 1
			vim.g.gruvbox_better_performance = 1
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		priority = 1000,
		opts = {},
	},
	{
		"sainnhe/sonokai",
		lazy = true,
	},
}
