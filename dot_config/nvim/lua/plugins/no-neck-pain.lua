return {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	opts = {
		width = 130,
		-- autocmds = {
		-- 	skipEnteringNoNeckPainBuffer = true,
		-- },
	},
	init = function()
		local map = require("stuff.functions").map
		map("n", "<Leader>n", "<CMD>NoNeckPain<CR>", { desc = "NoNeckPain" })
	end,
}
