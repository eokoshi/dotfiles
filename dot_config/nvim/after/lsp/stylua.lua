---@type vim.lsp.Config
return {
	cmd = {
		"stylua",
		"--lsp",
		"--config-path",
		"$XDG_CONFIG_HOME/nvim/.stylua.toml",
	},
}
