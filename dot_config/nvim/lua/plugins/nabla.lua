--if true then return {} end

return {
	{
		"jbyuki/nabla.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		lazy = true,
		event = "VeryLazy",
	},
}
