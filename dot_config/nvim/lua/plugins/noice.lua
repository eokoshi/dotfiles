return {
	"folke/noice.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	event = "VeryLazy",
	opts = {
		presets = {
			bottom_search = true,
			lsp_doc_border = true,
			-- command_palette = true, -- does not work with blink cmdline completions
		},
		views = {
			split = {
				enter = false,
				size = "auto",
			},
			popup = {
				size = "auto",
			},
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
						{ find = "%d+ lines" },
						{ find = "%d+ more lines" },
						{ find = "%d+ fewer" },
						{ find = "is deprecated" },
						{ find = "Hunk %d+ of %d+" },
					},
				},
				view = "mini",
			},
			{
				filter = {
					event = "msg_show",
					kind = "lua_print",
					find = "[nvim-treesitter]",
				},
				view = "mini",
			},
			{ -- send long messages to view
				filter = {
					event = "msg_show",
					min_height = 10,
					cmdline = false,
				},
				view = "split",
			},
			{ -- send cmdline outputs to popup
				filter = {
					event = "msg_show",
					min_height = 5,
					cmdline = true,
				},
				view = "popup",
			},
		},
		lsp = {
			override = {
				["cmp.entry.get_documentation"] = false,
			},
		},
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
		},
		popupmenu = {
			enabled = true,
		},
	},
	init = function()
		local map = require("stuff.functions").map
		map({ "n", "i", "s" }, "<C-n>", function()
			require("noice.lsp").scroll(4)
		end, { desc = "Scroll hover down" })
		map({ "n", "i", "s" }, "<C-p>", function()
			require("noice.lsp").scroll(-4)
		end, { desc = "Scroll hover up" })
	end,
}
