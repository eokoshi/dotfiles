---@type vim.lsp.Config
return {
	settings = {
		python = {
			commentFoldingRanges = true,
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
