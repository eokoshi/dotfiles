-- if true then return {} end

return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						format = {
							enable = false,
						},
					},
				},
			})

			vim.lsp.config("basedpyright", {
				settings = {
					basedpyright = {
						disableOrganizeImports = true,
					},
				},
			})

			vim.lsp.config("ruff", {
				on_attach = function(client, bufnr)
					client.server_capabilities.hoverProvider = false
				end,
			})
		end,
	},
}
