-- if true then return {} end

return {
	"hamidi-dev/org-list.nvim",
	dependencies = {
		"tpope/vim-repeat", -- for repeatable actions with '.'
	},
	ft = { "markdown" },
	opts = {
		mapping = {
			key = "<Leader>ml",
			desc = "Cycle through list types",
		},
	},
}
