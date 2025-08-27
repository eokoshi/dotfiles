-- if true then return {} end

return {
	"folke/snacks.nvim",
	dependencies = {
		"MaximilianLloyd/ascii.nvim",
	},
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			preset = {
				header = table.concat(require("ascii").art.animals.cats.boxy, "\n"),
				keys = {
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = "󰙅 ",
						key = "e",
						desc = "File Explorer",
						action = function()
							require("neo-tree.command").execute({ position = "float" })
						end,
					},
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{
						icon = " ",
						key = "w",
						desc = "Find Word",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{ icon = " ", key = "r", desc = "Recents", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = function()
							local dir = os.getenv("HOME") .. "/.local/share/chezmoi"
							require("neo-tree.command").execute({ position = "float", dir = dir })
						end,
					},
					{
						icon = " ",
						key = "s",
						desc = "Restore Session",
						action = function()
							local function get_session_name()
								local name = vim.fn.getcwd()
								local branch = vim.trim(vim.fn.system("git branch --show-current"))
								if vim.v.shell_error == 0 then
									return name .. branch
								else
									return name
								end
							end
							require("resession").load(get_session_name(), { dir = "dirsession", silence_errors = true })
						end,
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
		explorer = { enabled = false },
		image = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		lazygit = {
			---@diagnostic disable-next-line: missing-fields
			theme = {
				selectedLineBgColor = { bg = "ColorColumn" },
			},
		},
		picker = {
			layout = function()
				if vim.o.columns >= 140 then
					return { preset = "default" }
				else
					return {
						layout = {
							box = "vertical",
							backdrop = false,
							width = 0.8,
							min_width = 90,
							height = 0.8,
							min_height = 30,
							border = "rounded",
							title = "{title} {live} {flags}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "bottom" },
							{
								win = "preview",
								title = "{preview}",
								height = 0.8,
								border = "top",
								wo = { wrap = true, statuscolumn = "%l ", relativenumber = false, foldcolumn = "0" },
							},
						},
					}
				end
			end,
			sources = {
				explorer = {
					exclude = { ".gitattributes", "__**__" },
					follow_file = true,
					hidden = true,
					ignored = true,
					follow = true,
				},
			},
		},
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scratch = {
			win = {
				wo = {
					number = true,
					relativenumber = false,
					numberwidth = 2,
					statuscolumn = "%l %s",
					winhighlight = "Normal:Normal,FloatBorder:SnacksPickerBorder,FloatTitle:SnacksPickerTitle",
				},
				relative = "editor",
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
