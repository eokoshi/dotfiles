return {
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		--@type trouble.Config
		opts = {
			focus = true,
			modes = {
				diagnostics = {
					mode = "diagnostics",
					preview = {
						type = "split",
						relative = "win",
						position = "right",
						size = 0.3,
					},
					filter = function(items)
						local severity = vim.diagnostic.severity.HINT
						for _, item in ipairs(items) do
							severity = math.min(severity, item.severity)
						end
						return vim.tbl_filter(function(item)
							return item.severity == severity
						end, items)
					end,
				},
			},
			win = {
				colorcolumn = false,
			},
		},
		init = function()
			local map = require("stuff.functions").map
			map("n", "<Leader>t", "", { desc = "Trouble" })
			map("n", "<Leader>td", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "diagnostics" })
			map("n", "<Leader>tD", "<CMD>Trouble diagnostics toggle<CR>", { desc = "workspace diagnostics" })
			map(
				"n",
				"<Leader>ts",
				"<CMD>Trouble symbols toggle focus=true pinned=true win.relative=editor<CR>",
				{ desc = "symbols" }
			)
			map(
				"n",
				"<Leader>tS",
				"<CMD>Trouble lsp_document_symbols toggle pinned=true win.relative=editor win.position=right<CR>",
				{ desc = "all symbols" }
			)
			map("n", "<Leader>tl", "<CMD>Trouble loclist<CR>", { desc = "loclist" })
			map("n", "<Leader>tq", "<CMD>Trouble qflist<CR>", { desc = "quickfix list" })
			map("n", "<Leader>tt", "<CMD>TodoTrouble<CR>", { desc = "Todo List" })
		end,
	},
}
