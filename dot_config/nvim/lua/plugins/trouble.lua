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
	},
	{
		"eokoshi/lualine.nvim",
		opts = function(_, opts)
			local trouble = require("trouble")
			local symbols = trouble.statusline({
				mode = "lsp_document_symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:BufferInactiveSign}",
				hl_group = "lualine_x_normal",
			})
			table.insert(opts.tabline.lualine_x, {
				symbols.get,
				cond = symbols.has,
			})
		end,
	},
}
