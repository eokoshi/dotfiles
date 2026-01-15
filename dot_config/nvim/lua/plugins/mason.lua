local installs = {}
if vim.fn.has("win32") == 1 then
	installs = {
		-- LSP
		-- "basedpyright",
		-- "ty",
		"marksman",

		-- Formatters
		-- "ruff",
		"prettier",
		"fixjson",

		-- DAP

		-- Other
		-- "tree-sitter-cli",
	}
else -- linux
	installs = {
		-- LSP
		"lua-language-server",
		"ty",
		"bashls",
		"marksman",

		-- Formatters
		"stylua",
		"ruff",
		"prettier",
		"fixjson",
		"pyproject-fmt",

		-- DAP
		"debugpy",

		-- Other
		"tree-sitter-cli",
	}
end

return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		opts = {
			-- Make sure to use the names found in `:Mason`
			ensure_installed = installs,
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {},
	},
}
