---@type vim.lsp.Config
return {
	cmd = {"stylua", "--lsp"},
	filetypes = {"lua"},
	{ ".stylua.toml", "stylua.toml", ".editorconfig", "init.lua" },
}
