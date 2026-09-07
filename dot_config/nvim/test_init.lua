vim.lsp.config("pyrefly", { ---@as vim.lsp.Config
	cmd = { "pyrefly", "lsp" },
	filetypes = { "python" },
	root_markers = {
		"pyrefly.toml",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		".git",
	},
	on_exit = function(code, _, _)
		vim.schedule(function() vim.notify("Closing Pyrefly LSP exited with code: " .. code, vim.log.levels.INFO) end)
	end,
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
})
vim.lsp.enable("pyrefly")

vim.o.number = true
vim.o.statuscolumn = "%l %s %C"
vim.o.foldcolumn = "2"
vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.opt_local.foldmethod = "expr"
