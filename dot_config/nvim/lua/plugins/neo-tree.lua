return {
	"nvim-neo-tree/neo-tree.nvim",
	config = function(_, opts)
		opts.sources = {
			"filesystem",
			"document_symbols",
		}
		opts.filesystem.filtered_items.visible = true
		opts.filesystem.filtered_items.never_show_by_pattern = {
			"**/__pycache__",
		}
		opts.source_selector.sources = {
			{ source = "filesystem" },
			{ source = "document_symbols" },
		}
		require("neo-tree").setup(opts)
	end,
}
