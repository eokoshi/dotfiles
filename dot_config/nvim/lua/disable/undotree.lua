return {
	"mbbill/undotree",
	event = "VeryLazy",
	init = function()
		vim.g.undotree_WindowLayout = 2
		vim.g.undotree_setFocusWhenToggle = 1
		vim.g.undotree_TreeNodeShape = ""
		vim.g.undotree_TreeVertShape = "┃"
		vim.g.undotree_TreeSplitShape = "━┛"
		vim.g.undotree_TreeReturnShape = "━┓"

		local map = require("stuff.functions").map
		map("n", "<Leader>U", "<CMD>UndotreeToggle<CR>", { desc = "Open Undotree" })
	end,
}
