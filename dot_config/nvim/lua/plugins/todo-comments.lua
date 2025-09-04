-- if true then return {} end

return {
	-- FIX:
	-- TODO:
	-- HACK:
	-- WARN:
	-- PERF:
	-- NOTE:
	-- TEST:
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		opts = {
			keywords = {
				FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
				TODO = { icon = " ", color = "info" },
				HACK = { icon = "󰣈 ", color = "test" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
				PERF = { icon = " ", color = "test", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO", "IDEA" } },
				TEST = { icon = "󰟶 ", color = "default", alt = { "TESTING", "PASSED", "FAILED" } },
			},
			search = {
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--glob=!conf/*.yaml",
				},
			},
			colors = {
				default = { "DiagnosticOk", "Identifier", "#7C3AED" },
				test = { "Linkage", "Identifier", "#FF00FF" },
			},
		},
	},
}
