--@type LazySpec
return {
	"folke/noice.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	event = "VeryLazy",
	opts = {
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
		},
		messages = {
			-- view = "mini",
			-- view_error = "mini",
			-- view_warn = "notify",
		},
	},
}
