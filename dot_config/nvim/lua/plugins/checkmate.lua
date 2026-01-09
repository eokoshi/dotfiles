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
					return tostring(os.date("%Y%m%d %H:%M"))
				end,
				key = "<leader>mcs",
				sort_order = 20,
			},
			-- Example: A @done tag that also sets the todo item state when it is added and removed
			done = {
				aliases = { "completed", "finished" },
				style = { fg = "#96de7a" },
				get_value = function()
					return tostring(os.date("%Y%m%d %H:%M"))
				end,
				on_add = function(todo_item)
					require("checkmate").set_todo_state(todo_item, "checked")
				end,
				on_remove = function(todo_item)
					require("checkmate").set_todo_state(todo_item, "unchecked")
				end,
				sort_order = 30,
			},
			due = {
				aliases = { "deadline", "by", "until", "duedate" },
				key = "<leader>mcd",
				get_value = function()
					return tostring(os.date("%Y%m%d", os.time() + (24 * 60 * 60 * 2))) -- +2 days by default
				end,
				jump_to_on_insert = "value",
				select_on_insert = true,
				style = function(context)
					local duedate = os.time({
						year = context.value:sub(1, 4),
						month = context.value:sub(5, 6),
						day = context.value:sub(7, 8),
					})
					local remaining = os.difftime(os.time(), duedate) / (24 * 60 * 60)
					if remaining > 0 then -- error
						return { sp = "red", undercurl = true }
					elseif remaining > -1 then
						return { bg = "#ff5555", bold = true }
					elseif remaining > -7 then
						return { bg = "#ff6700", bold = true }
					elseif remaining > -14 then
						return { bg = "orange" }
					elseif remaining > -21 then
						return { bg = "gold" }
					elseif remaining > -28 then
						return { bg = "greenyellow" }
					else
						return { fg = "green" }
					end
				end,
				sort_order = 15,
			},
		},
	},
	init = function()
		local map = require("stuff.functions").map
		map({ "n", "v" }, "<leader>mc", "", { desc = "Checkmate" })
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
