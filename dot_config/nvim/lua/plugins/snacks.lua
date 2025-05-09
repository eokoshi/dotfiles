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
			},
			sections = {
				{ section = "header" },
				{
					pane = 2,
					section = "terminal",
					cmd = "fortune",
					height = 5,
					padding = 2,
				},
				{ section = "keys", gap = 1, padding = 2 },
				{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2 },
				{
					pane = 2,
					icon = " ",
					title = "Projects",
					section = "projects",
					indent = 2,
					padding = 2,
				},
				{
					pane = 2,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						return require("snacks").git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 2,
					ttl = 5 * 60,
					indent = 3,
				},
				{ section = "startup" },
			},
		},
	},
}
