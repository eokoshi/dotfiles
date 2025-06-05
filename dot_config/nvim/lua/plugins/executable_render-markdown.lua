---@type LazySpec
return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.icons",
		}, -- if you use standalone mini plugins
		version = "^8.4.0",
		ft = {
			"markdown",
			"ipynb",
			"codecompanion",
		},
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			-- heading = {
			-- 	position = "inline",
			-- },
			heading = {
				sign = false,
				position = "inline",
				-- border = true,
				-- below = "▔",
				-- above = "▁",
				-- left_pad = 0,
				-- icons = { "█ ", "██ ", "███ ", "████ ", "█████ ", "██████ ", },
				-- icons = { "󰬺. ", "󰬻. ", "󰬼. ", "󰬽. ", "󰬾. ", "󰬿. " },
				-- icons = { "󰲠 ", "󰲢 ", "󰲤 ", "󰲦 ", "󰲨 ", "󰲪 " },
				-- icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
				icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
			},
			code = {
				sign = false,
			},
			completions = {
				blink = {
					enabled = true,
				},
			},
			latex = { enabled = false },
			win_options = {
				conceallevel = {
					default = vim.api.nvim_get_option_value("conceallevel", {}),
					rendered = 2, -- <- especially this, so that both plugins play nice
				},
			},
		},
	},
}

