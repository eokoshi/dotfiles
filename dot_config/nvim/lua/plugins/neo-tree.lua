if true then return {} end

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	lazy = false, -- neo-tree will lazily load itself
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {
		sources = {
			"filesystem",
			"buffers",
			"document_symbols",
		},
		filesystem = {
			filtered_items = {
				visible = true,
				never_show_by_pattern = {
					"**/__pycache__",
					"**/__marimo__",
				},
			},
			follow_current_file = {
				enabled = true,
			},
		},
		source_selector = {
			truncation_character = "…",
			winbar = true,
			show_scrolled_off_parent_node = true,
			sources = {
				{ source = "filesystem" },
				{ source = "buffers" },
				{ source = "document_symbols" },
			},
		},
	},
}
