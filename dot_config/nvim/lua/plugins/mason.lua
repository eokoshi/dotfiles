return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		opts = {
			-- Make sure to use the names found in `:Mason`
			ensure_installed = {
				-- LSP
				"lua-language-server",
				"basedpyright",
				"json-lsp",
				"bashls",
				"marksman",

				-- Formatters
				"stylua",
				"ruff",
				"air",

				-- DAP
				"debugpy",

				-- Other
				"tree-sitter-cli",
				"jupytext",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {},
	},
}
