return {
	"bngarren/checkmate.nvim",
	ft = "markdown",
	opts = {
		files = { "*.md", "todo", "*.todo", "TODO" },
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
		keys = false,
	},
	init = function()
		local map = require("stuff.functions").map
		map({ "n", "v" }, "mcc", "<cmd>Checkmate create<CR>", { desc = "Create todo item" })
		map({ "n", "v" }, "mcr", "<cmd>Checkmate remove<CR>", { desc = "Remove todo marker (convert to text)" })
		map(
			{ "n", "v" },
			"mcR",
			"<cmd>Checkmate remove_all_metadata<CR>",
			{ desc = "Remove all metadata from a todo item" }
		)
		map(
			{ "n", "v" },
			"mca",
			"<cmd>Checkmate archive<CR>",
			{ desc = "Archive checked/completed todo items (move to bottom section)" }
		)
		map(
			{ "n", "v" },
			"mcm",
			"<cmd>Checkmate metadata select_value<CR>",
			{ desc = "Update the value of a metadata tag under the cursor" }
		)
	end,
}
