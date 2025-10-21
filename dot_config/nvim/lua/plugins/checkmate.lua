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
		-- Default keymappings
		keys = {
			["<leader>mct"] = {
				rhs = "<cmd>Checkmate toggle<CR>",
				desc = "Toggle todo item",
				modes = { "n", "v" },
			},
			["<leader>mcc"] = {
				rhs = "<cmd>Checkmate check<CR>",
				desc = "Set todo item as checked (done)",
				modes = { "n", "v" },
			},
			["<leader>mcu"] = {
				rhs = "<cmd>Checkmate uncheck<CR>",
				desc = "Set todo item as unchecked (not done)",
				modes = { "n", "v" },
			},
			["<leader>mc="] = {
				rhs = "<cmd>Checkmate cycle_next<CR>",
				desc = "Cycle todo item(s) to the next state",
				modes = { "n", "v" },
			},
			["<leader>mc-"] = {
				rhs = "<cmd>Checkmate cycle_previous<CR>",
				desc = "Cycle todo item(s) to the previous state",
				modes = { "n", "v" },
			},
			["<leader>mcn"] = {
				rhs = "<cmd>Checkmate create<CR>",
				desc = "Create todo item",
				modes = { "n", "v" },
			},
			["<leader>mcr"] = {
				rhs = "<cmd>Checkmate remove<CR>",
				desc = "Remove todo marker (convert to text)",
				modes = { "n", "v" },
			},
			["<leader>mcR"] = {
				rhs = "<cmd>Checkmate remove_all_metadata<CR>",
				desc = "Remove all metadata from a todo item",
				modes = { "n", "v" },
			},
			["<leader>mca"] = {
				rhs = "<cmd>Checkmate archive<CR>",
				desc = "Archive checked/completed todo items (move to bottom section)",
				modes = { "n" },
			},
			["<leader>mcv"] = {
				rhs = "<cmd>Checkmate metadata select_value<CR>",
				desc = "Update the value of a metadata tag under the cursor",
				modes = { "n" },
			},
			["<leader>mc]"] = {
				rhs = "<cmd>Checkmate metadata jump_next<CR>",
				desc = "Move cursor to next metadata tag",
				modes = { "n" },
			},
			["<leader>mc["] = {
				rhs = "<cmd>Checkmate metadata jump_previous<CR>",
				desc = "Move cursor to previous metadata tag",
				modes = { "n" },
			},
		},
	},
}
