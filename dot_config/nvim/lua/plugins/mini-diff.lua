-- stylua: ignore
-- if true then return {} end

local icons = require("stuff.icons")
return {
	"echasnovski/mini.diff",
	version = false,
	opts = {
		view = {
			style = "sign",
			signs = {
				add = icons.git.gitbar,
				change = icons.git.gitbar,
				delete = icons.git.col_delete,
			},
		},
	},
}
