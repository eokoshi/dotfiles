return {
	"folke/snacks.nvim",
	version = "*",
	dependencies = {},
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				header = table.concat(require("ascii").art.animals.cats.boxy, "\n"),
				keys = {
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = "󰙅 ",
						key = "e",
						desc = "File Explorer",
						action = function()
							Snacks.explorer({
								exclude = { ".gitattributes", "__**__" },
								follow_file = true,
								hidden = true,
								ignored = true,
								follow = true,
							})
						end,
					},
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{ icon = " ", key = "r", desc = "Recents", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = function()
							vim.fn.chdir(vim.fn.stdpath("config"))
							Snacks.explorer.open()
						end,
					},
					{
						icon = " ",
						key = "s",
						desc = "Restore Session",
						action = ":lua require('resession').load('last')",
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{
					section = "keys",
					gap = 1,
					padding = 2,
				},
				{
					section = "recent_files",
					icon = " ",
					title = "Recent Files",
					indent = 2,
					padding = 2,
					limit = 10,
				},
				{
					section = "startup",
				},
			},
		},
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scratch = {
			enabled = true,
			win = {
				wo = {
					number = true,
					relativenumber = false,
					numberwidth = 2,
					statuscolumn = "%l %s",
				},
			},
		},
		statuscolumn = { enabled = false },
	},
	init = function()
		local Snacks = require("snacks")
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd -- Override print to use snacks for `:=` command
			end,
		})
	end,
}
