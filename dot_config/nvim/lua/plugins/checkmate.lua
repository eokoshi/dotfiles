return {
	"bngarren/checkmate.nvim",
	ft = "markdown",
	opts = {
		files = { "*.md" },
		metadata = {
			started = {
				get_value = function()
					return tostring(os.date("%Y-%m-%d %H:%M"))
				end,
			},
		},
		todo_states = {
			checked = {
				marker = "󰸞",
			},
		},
	},
}
