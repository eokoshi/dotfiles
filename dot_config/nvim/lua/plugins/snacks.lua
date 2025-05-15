---@type LazySpec
return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	---@type snacks.Config
	opts = {
		dashboard = {
			preset = {
				-- stylua: ignore start
				header = [[
  ,-.       _,---._ __  / \
 /  )    .-'       `./ /   \
 (  (   ,'            `/    /|
  \  `-"             \'\   / |
   `.              ,  \ \ /  |
    /`.          ,'-`----Y   |
   (            ;        |   '
  |  ,-.    ,-'         |  /
  |  | (   |            | /
 )  |  \  `.___________|/
.  `--'   `--'               .]],
				-- stylua: ignore end
				keys = {
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{ icon = " ", key = "e", desc = "File Explorer", action = ":Neotree current" },
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
					{ icon = " ", key = "r", desc = "Recents", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					{ icon = " ", key = "c", desc = "Config", action = ":Neotree current dir=~/.config/nvim" },
					{ icon = " ", key = "s", desc = "Restore Session", action = "<Leader>Sl" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{
					section = "header",
				},
				{
					section = "terminal",
					cmd = "cbonsai --live -t 2",
					height = 10,
					padding = 2,
					pane = 2,
				},
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
					limit = 7,
					pane = 2,
				},
				{
					section = "projects",
					icon = " ",
					title = "Projects",
					indent = 2,
					padding = 2,
					limit = 3,
					pane = 2,
				},
				{
					section = "terminal",
					icon = " ",
					title = "Git Status",
					enabled = function()
						return require("snacks").git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 2,
					ttl = 5 * 60,
					indent = 3,
					pane = 2,
				},
				{
					section = "startup",
				},
			},
		},
	},
}
