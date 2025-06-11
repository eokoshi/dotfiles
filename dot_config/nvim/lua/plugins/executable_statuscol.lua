-- stylua: ignore
-- if true then return {} end

return {
	{
		"luukvbaal/statuscol.nvim",
		event = "VeryLazy",
		init = function()
			vim.opt.number = true
			vim.opt.relativenumber = true
			vim.opt.numberwidth = 2
			vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
			vim.opt.foldcolumn = "1"
			vim.opt.foldlevelstart = 99
			vim.opt.foldtext = vim.lsp.foldtext()
		end,
		opts = function()
			local builtin = require("statuscol.builtin")
			return {
				bt_ignore = { "nofile" },
				setopt = true,
				relculright = true,
				segments = {
					{ text = { "%s" }, click = "v:lua.ScSa" },
					{
						text = { builtin.lnumfunc, " " },
						condition = { true, builtin.not_empty },
						click = "v:lua.ScLa",
					},
					{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
				},
			}
		end,
	},
}
