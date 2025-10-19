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
			-- "document_symbols",
		},
		filesystem = {
			filtered_items = {
				visible = true,
				never_show_by_pattern = {
					"**/__**__",
				},
			},
			follow_current_file = {
				enabled = true,
			},
			hijack_netrw_behavior = "open_current",
		},
		source_selector = {
			truncation_character = "…",
			winbar = true,
			show_scrolled_off_parent_node = true,
			sources = {
				{ source = "filesystem" },
				{ source = "buffers" },
				-- { source = "document_symbols" },
			},
		},
		window = {
			mappings = {
				["<space>"] = "none",
				["l"] = "open",
				["h"] = "close_node",
				["L"] = "focus_preview",
				["<C-n>"] = { "scroll_preview", config = { direction = 10 } },
				["<C-p>"] = { "scroll_preview", config = { direction = -10 } },
			},
		},
	},
	init = function ()
		local map = require("stuff.functions").map
		map("n", "<Leader>e", "<CMD>Neotree toggle left<CR>", { desc = "File explorer" })
	end
}
