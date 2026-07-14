---@type vim.lsp.Config
return {
	settings = {
		Lua = {
			workspace = {
				maxPreload = 1000,
			},
			format = {
				enable = false,
			},
		},
	},
}
