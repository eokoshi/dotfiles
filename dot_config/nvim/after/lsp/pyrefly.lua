---@type vim.lsp.Config
return {
	settings = {
		python = {
			commentFoldingRanges = true, -- just doesnt work right now 20260908
			analysis = {
				completeFunctionParens = false,
				showHoverGoToLinks = false,
			},
			pyrefly = {
				disableLanguageServices = false,
			},
		},
	},
	-- folding is broken, maybe because of custom 'kinds'?
	on_attach = function(client, bufnr)
		if client.server_capabilities then client.server_capabilities.foldingRangeProvider = false end
	end,
}
