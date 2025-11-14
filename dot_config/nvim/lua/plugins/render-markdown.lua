return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = {
			"markdown",
			"ipynb",
			"codecompanion",
		},
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
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
				position = "right",
				width = "block",
				right_pad = 1,
				min_width = 84,
				border = "thick",
				language_right = "█",
			},
			checkbox = { enabled = false },
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
