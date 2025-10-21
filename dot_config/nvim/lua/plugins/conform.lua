return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff" },
			r = { "air" },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
	init = function()
		local map = require("stuff.functions").map
		local conform = require("conform")
		map("n", "<Leader>bf", function()
			conform.format()
		end, { desc = "format buffer" })
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
