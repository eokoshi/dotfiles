---@type vim.lsp.Config
return {
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			analysis = {
				ignore = { "*" }, -- use ruff for linting
			},
		},
	},
}
