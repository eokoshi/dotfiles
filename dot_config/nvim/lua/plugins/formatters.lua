-- if true then return {} end

return {
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"nvim-lua/plenary.nvim",
			"nvimtools/none-ls.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "NullLsInstall", "NullLsUninstall" },
		config = function()
			require("mason").setup()
			require("mason-null-ls").setup({ handlers = {} })
			require("null-ls").setup()
		end,
	},
}
