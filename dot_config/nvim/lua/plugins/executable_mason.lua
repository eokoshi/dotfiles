--@type LazySpec
return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		opts_extend = { "ensure_installed" },
		opts = {
			-- Make sure to use the names found in `:Mason`
			ensure_installed = {
				-- install language servers
				"lua-language-server",
				"basedpyright",
				"json-lsp",

				-- install formatters
				"stylua",
				"ruff",
				"marksman",

				-- install debuggers
				"debugpy",

				-- install any other package
				"tree-sitter-cli",
				"jupytext",
			},
			integrations = {
				["mason-lspconfig"] = true,
				["mason-null-ls"] = true,
				["mason-nvim-dap"] = true,
			},
		},
	},
}
