-- if true then return {} end

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
				{ pattern = "buffer", icon = icons.basic.buffer, color = "green" },
				{ pattern = "explorer", icon = icons.basic.explorer, color = "red" },
				{ pattern = "undotree", icon = icons.basic.undotree, color = "red" },
				{ pattern = "history", icon = icons.basic.history, color = "yellow" },
				{ pattern = "language", icon = icons.basic.language, color = "purple" },
				{ pattern = "config", icon = icons.basic.config, color = "orange" },
				{ pattern = "packages", icon = icons.basic.packages, color = "red" },
				{ pattern = "extras", icon = icons.basic.extras, color = "yellow" },
				{ pattern = "home", icon = icons.basic.home, color = "purple" },
				{ pattern = "cd", icon = icons.basic.cd, color = "cyan" },
				{ pattern = "math", icon = icons.basic.math, color = "purple" },
				{ pattern = "fold", icon = icons.folds.foldclose, color = "gray" },
				{ pattern = "right", icon = icons.basic.right, color = "azure" },
				{ pattern = "left", icon = icons.basic.left, color = "azure" },
				{ pattern = "top", icon = icons.basic.top, color = "azure" },
				{ pattern = "bottom", icon = icons.basic.bottom, color = "azure" },
				{ pattern = "center", icon = icons.basic.center, color = "azure" },
				{ pattern = "list", icon = icons.basic.list, color = "blue" },
				{ pattern = "chatbot", icon = icons.basic.ai, color = "gray" },
				{ pattern = "markdown", icon = icons.basic.markdown, color = "purple" },
				{ pattern = "debugger", icon = icons.debug.bug, color = "red" },
				{ pattern = "trouble", icon = icons.debug.bug, color = "red" },
				{ pattern = "overlook", icon = icons.basic.popup, color = "blue" },
			},
		},
		win = {
			no_overlap = false,
		},
	},
}
