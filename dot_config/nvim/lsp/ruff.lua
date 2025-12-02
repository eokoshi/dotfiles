---@type vim.lsp.Config
return {
	on_attach = function(client, _)
		client.server_capabilities.hoverProvider = false
	end,
	init_options = {
		settings = {
			configurationPreference = "filesystemFirst",
			lineLength = 120,
		},
	},
}
