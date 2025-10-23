---@type vim.lsp.Config
return {
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				-- ignore = { "*" }, -- use ruff for linting
			},
		},
	},
}
