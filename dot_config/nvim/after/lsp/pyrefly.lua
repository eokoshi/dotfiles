---@type vim.lsp.Config
return {
	settings = {
		python = {
			analysis = {
				completeFunctionParens = true,
				showHoverGoToLinks = false,
			},
			pyrefly = {
				displayTypeErrors = "force-off",
			},
		},
	},
}
