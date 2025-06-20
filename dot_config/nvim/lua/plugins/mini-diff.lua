-- if true then return {} end

local icons = require("stuff.icons")
return {
	"echasnovski/mini.diff",
	version = false,
	event = "VeryLazy",
	opts = {
		view = {
			style = "sign",
			priority = 1,
			signs = {
				add = icons.git.gitbar,
				change = icons.git.gitbar,
				delete = icons.git.col_delete,
			},
		},
	},
}
