return {
	{
		"luukvbaal/statuscol.nvim",
		enabled = true,
		event = { "BufEnter", "User ResessionLoadPost" },
		init = function()
			vim.opt.number = true
			vim.opt.relativenumber = true
			vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
			vim.opt.foldcolumn = "1"
			vim.opt.foldlevelstart = 99
			vim.opt.foldtext = vim.lsp.foldtext()
		end,
		opts = function()
			local builtin = require("statuscol.builtin")
			return {
				setopt = true,
				relculright = true,
				segments = {
					{ text = { " ", builtin.foldfunc }, click = "v:lua.ScFa" },
					{
						text = { builtin.lnumfunc, " " },
						condition = { true, builtin.not_empty },
						click = "v:lua.ScLa",
					},
					{ text = { "%s" }, click = "v:lua.ScSa" },
				},
			}
		end,
	},
}
