---@diagnostic disable: missing-fields
return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	---@module "markview"
	---@type markview.config
	opts = {
		preview = {
			icon_provider = "mini",
			hybrid_modes = { "n", "no", "c", "t" },
			enable_hybrid_mode = true,
			linewise_hybrid_mode = true,
		},
		markdown = {
			headings = {
				shift_width = 0,
			},
			list_items = {
				marker_minus = {
					add_padding = false,
				},
				marker_star = {
					add_padding = false,
					text = "-",
				},
			},
			tables = {
				parts = {
					top = { "╭", "─", "╮", "┬" },
					header = { "│", "│", "│" },
					separator = { "├", "─", "┤", "┼" },
					row = { "│", "│", "│" },
					bottom = { "╰", "─", "╯", "┴" },
					overlap = { "┝", "━", "┥", "┿" },
					align_left = "╼",
					align_right = "╾",
					align_center = { "╴", "╶" },
				},
			},
		},
		markdown_inline = {
			checkboxes = {
				enable = false,
			},
		},
		latex = {
			enable = false,
		},
	},
}
