---@type vim.lsp.Config
return {
	settings = {
		python = {
			analysis = {
				completeFunctionParens = true,
				showHoverGoToLink = false,
			},
			pyrefly = {
				displayTypeErrors = "force-off",
			},
		},
	},
}
