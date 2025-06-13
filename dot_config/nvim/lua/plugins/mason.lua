-- if true then return {} end

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
		opts = {
			-- Make sure to use the names found in `:Mason`
			ensure_installed = {
				-- LSP
				"lua-language-server",
				"basedpyright",
				"json-lsp",

				-- Formatters
				"stylua",
				"ruff",
				"marksman",
				"jupytext",
				"air",

				-- DAP
				"debugpy",

				-- Other
				"tree-sitter-cli",
			},
			integrations = {
				["mason-lspconfig"] = true,
				["mason-null-ls"] = true,
				["mason-nvim-dap"] = false,
			},
		},
	},
}
