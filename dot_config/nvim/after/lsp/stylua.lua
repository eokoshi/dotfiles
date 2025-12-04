---@type vim.lsp.Config
return {
	cmd = {
		"stylua",
		"--lsp",
		"--config-path",
		vim.fn.stdpath("config") .. "/.stylua.toml",
	},
}
