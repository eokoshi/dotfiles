---@type LazySpec
return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
		end,
		settings = {
			Lua = {
				format = {
					enable = false,
				},
			},
		},
	},
}
