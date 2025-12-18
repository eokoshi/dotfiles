return {
	"WilliamHsieh/overlook.nvim",
	event = "VeryLazy",
	opts = {},
	init = function()
		local map = require("stuff.functions").map
		-- map("n", "<Leader>o", "", { desc = "Overlook" })
		map("n", "go", require("overlook.api").peek_definition, { desc = "Peek definition" })
		-- map("n", "<leader>op", require("overlook.api").peek_cursor, { desc = "Peek cursor" })
		-- map("n", "<leader>ou", require("overlook.api").restore_popup, { desc = "Restore last popup" })
		-- map("n", "<leader>oU", require("overlook.api").restore_all_popups, { desc = "Restore all popups" })
		-- map("n", "<leader>oc", require("overlook.api").close_all, { desc = "Close all popups" })
		-- map("n", "<leader>os", require("overlook.api").open_in_split, { desc = "Open popup in split" })
		-- map("n", "<leader>ov", require("overlook.api").open_in_vsplit, { desc = "Open popup in vsplit" })
		-- map("n", "<leader>ot", require("overlook.api").open_in_tab, { desc = "Open popup in tab" })
		-- map(
		-- 	"n",
		-- 	"<leader>oo",
		-- 	require("overlook.api").open_in_original_window,
		-- 	{ desc = "Open popup in current window" }
		-- )
	end,
}
