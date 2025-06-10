local icons = require("stuff.icons")
return {
	"folke/which-key.nvim",
	dependencies = {
		"echasnovski/mini.icons",
	},
	event = "VeryLazy",
	opts = {
		icons = {
			separator = "",
			group = "",
			rules = {
				{ pattern = "buffer", icon = icons.whichkey.buffer, color = "green" },
				{ pattern = "explorer", icon = icons.whichkey.explorer, color = "red" },
				{ pattern = "undotree", icon = icons.whichkey.undotree, color = "red" },
				{ pattern = "history", icon = icons.whichkey.history, color = "yellow" },
				{ pattern = "language", icon = icons.whichkey.language, color = "purple" },
				{ pattern = "config", icon = icons.whichkey.config, color = "orange" },
				{ pattern = "packages", icon = icons.whichkey.packages, color = "red" },
				{ pattern = "extras", icon = icons.whichkey.extras, color = "yellow" },
				{ pattern = "home", icon = icons.whichkey.home, color = "purple" },
				{ pattern = "cd", icon = icons.whichkey.cd, color = "cyan" },
				{ pattern = "math", icon = icons.whichkey.math, color = "purple" },
				{ pattern = "fold", icon = icons.folds.foldclose, color = "gray" },
				{ pattern = "right", icon = icons.whichkey.right, color = "azure" },
				{ pattern = "left", icon = icons.whichkey.left, color = "azure" },
				{ pattern = "top", icon = icons.whichkey.top, color = "azure" },
				{ pattern = "bottom", icon = icons.whichkey.bottom, color = "azure" },
				{ pattern = "center", icon = icons.whichkey.center, color = "azure" },
				{ pattern = "list", icon = icons.whichkey.list, color = "blue" },
				{ pattern = "chatbot", icon = icons.whichkey.ai, color = "gray" },
			},
		},
	},
}
