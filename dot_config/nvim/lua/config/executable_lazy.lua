-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
vim.opt.statuscolumn = "%s "

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	-- defaults = {
	-- 	version = "*",
	-- },
	checker = { enabled = true },
	ui = {
		title = " 󰒲 lazy.nvim ",
		size = {
			width = 0.8,
			height = 0.8,
		},
		border = "rounded",
		wrap = false,
		install = {
			colorscheme = { "wildcharm" },
		},
		icons = require("stuff.icons").lazy,
	},
})
