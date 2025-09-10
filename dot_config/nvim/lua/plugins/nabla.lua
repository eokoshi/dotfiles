--if true then return {} end

return {
	{
		"jbyuki/nabla.nvim",
		dependencies = {
			-- "nvim-neo-tree/neo-tree.nvim",
			"mason-org/mason.nvim",
		},
		lazy = true,
		event = {
			"BufReadPre ~/Documents/Obsidian/*.md",
			"BufNewFile ~/Documents/Obsidian/*.md",
		},
	},
}
