vim.opt_local.signcolumn = "no"
vim.opt_local.statuscolumn = ""
vim.opt_local.foldcolumn = "0"
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.colorcolumn = "0"

local helpgroup = vim.api.nvim_create_augroup("HelpFileType", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	group = helpgroup,
	callback = function(args)
		local bufnr = args.buf
		local winnr = vim.api.nvim_get_current_win()
		if vim.bo[bufnr].filetype == "help" then vim.g.helpwin = winnr end
	end,
})
vim.api.nvim_create_autocmd("BufWinLeave", {
	group = helpgroup,
	callback = function(args)
		local bufnr = args.buf
		local winnr = vim.api.nvim_get_current_win()
		if vim.bo[bufnr].filetype == "help" then vim.g.helpwin = nil end
	end,
})
