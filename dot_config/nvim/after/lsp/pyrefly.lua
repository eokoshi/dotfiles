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
}
