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
			map(
				"n",
				"<Leader>td",
				"<CMD>Trouble diagnostics toggle focus=true filter.buf=0<CR>",
				{ desc = "diagnostics list" }
			)
			map("n", "<Leader>tD", "<CMD>Trouble diagnostics toggle<CR>", { desc = "workspace diagnostics list" })
			map(
				"n",
				"<Leader>ts",
				"<CMD>Trouble symbols toggle pinned=true win.relative=editor win.position=right<CR>",
				{ desc = "symbols" }
			)
			map("n", "<Leader>tt", "<CMD>TodoTrouble<CR>", { desc = "Todo List" })
		end,
	},
}
