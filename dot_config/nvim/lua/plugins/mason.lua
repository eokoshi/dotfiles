-- Customize Mason

---@type LazySpec
return {
	-- use mason-tool-installer for automatically installing Mason packages
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- overrides `require("mason-tool-installer").setup(...)`
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
				"selene",
				"tree-sitter-cli",
				"jupytext",
			},
		},
	},
}
