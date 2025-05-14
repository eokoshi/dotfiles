---@type LazySpec
return {
	"Saghen/blink.cmp",
	opts = {
		completion = {
			list = {
				selection = {
					preselect = true,
					auto_insert = true,
				},
			},
		},
		sources = {
			per_filetype = {
				codecompanion = { "codecompanion" },
			},
		},
	},
}
