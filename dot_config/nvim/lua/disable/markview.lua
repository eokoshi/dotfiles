return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	opts = {
		preview = {
			modes = { "v", "V", "n", "no", "c", "t" },
			icon_provider = "mini",
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
