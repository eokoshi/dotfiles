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
						-- analysis = {
						-- 	ignore = { "*" }, -- use ruff for linting
						-- },
					},
				},
			})

			vim.lsp.config("ruff", {
				on_attach = function(client, _)
					client.server_capabilities.hoverProvider = false
				end,
				init_options = {
					settings = {
						lineLength = 100,
						lint = {
							enable = false,
						},
						fixAll = false,
					},
				},
			})
		end,
		init = function()
			local lsp = vim.api.nvim_create_augroup("LspAutoformat", { clear = true })
			vim.api.nvim_create_autocmd("LspAttach", {
				group = lsp,
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
					if not client:supports_method("textDocument/willSaveWaitUntil") and client:supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = lsp,
							buffer = args.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
							end,
						})
					end
				end,
				desc = "Autoformat on save",
			})
		end,
	},
}
