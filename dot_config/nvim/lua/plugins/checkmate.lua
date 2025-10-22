return {
	"bngarren/checkmate.nvim",
	ft = "markdown",
	opts = {
		files = { "*.md", "todo", "*.todo", "TODO" },
		todo_states = {
			checked = {
				marker = "󰸞",
			},
		},
		keys = false,
		default_list_marker = "*",
		metadata = {
			-- Example: A @priority tag that has dynamic color based on the priority value
			priority = {
				style = function(context)
					local value = context.value:lower()
					if value == "high" then
						return { fg = "#ff5555", bold = true }
					elseif value == "medium" then
						return { fg = "#ffb86c" }
					elseif value == "low" then
						return { fg = "#8be9fd" }
					else -- fallback
						return { fg = "#8be9fd" }
					end
				end,
				get_value = function()
					return "medium" -- Default priority
				end,
				choices = function()
					return { "low", "medium", "high" }
				end,
				key = "<leader>mcp",
				sort_order = 10,
				jump_to_on_insert = "value",
				select_on_insert = true,
			},
			-- Example: A @started tag that uses a default date/time string when added
			started = {
				aliases = { "init" },
				style = { fg = "#9fd6d5" },
				get_value = function()
					return tostring(os.date("%Y-%m-%d %H:%M"))
				end,
				key = "<leader>mcs",
				sort_order = 20,
			},
			-- Example: A @done tag that also sets the todo item state when it is added and removed
			done = {
				aliases = { "completed", "finished" },
				style = { fg = "#96de7a" },
				get_value = function()
					return tostring(os.date("%m/%d/%y %H:%M"))
				end,
				key = "<leader>mcd",
				on_add = function(todo_item)
					require("checkmate").set_todo_item(todo_item, "checked")
				end,
				on_remove = function(todo_item)
					require("checkmate").set_todo_item(todo_item, "unchecked")
				end,
				sort_order = 30,
			},
		},
	},
	init = function()
		local map = require("stuff.functions").map
		map({ "n" }, "<CR>", "<cmd>Checkmate toggle<CR>", { desc = "Toggle todo item" })
		map({ "n", "v" }, "<leader>mct", "<cmd>Checkmate toggle<CR>", { desc = "Toggle todo item" })
		map(
			{ "n", "v" },
			"<leader>mc+",
			"<cmd>Checkmate cycle_next<CR>",
			{ desc = "Cycle todo item(s) to the next state" }
		)
		map(
			{ "n", "v" },
			"<leader>mc-",
			"<cmd>Checkmate cycle_previous<CR>",
			{ desc = "Cycle todo item(s) to the previous state" }
		)
		map({ "n", "v" }, "<leader>mcn", "<cmd>Checkmate create<CR>", { desc = "Create todo item" })
		map({ "n", "v" }, "<leader>mcr", "<cmd>Checkmate remove<CR>", { desc = "Remove todo marker (convert to text)" })
		map(
			{ "n", "v" },
			"<leader>mcR",
			"<cmd>Checkmate remove_all_metadata<CR>",
			{ desc = "Remove all metadata from a todo item" }
		)
		map(
			{ "n" },
			"<leader>mca",
			"<cmd>Checkmate archive<CR>",
			{ desc = "Archive checked/completed todo items (move to bottom section)" }
		)
		map(
			{ "n" },
			"<leader>mcv",
			"<cmd>Checkmate metadata select_value<CR>",
			{ desc = "Update the value of a metadata tag under the cursor" }
		)
		map(
			{ "n" },
			"<leader>mc]",
			"<cmd>Checkmate metadata jump_next<CR>",
			{ desc = "Move cursor to next metadata tag" }
		)
		map(
			{ "n" },
			"<leader>mc[",
			"<cmd>Checkmate metadata jump_previous<CR>",
			{ desc = "Move cursor to previous metadata tag" }
		)
	end,
}
