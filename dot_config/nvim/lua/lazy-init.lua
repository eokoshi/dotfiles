-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
require("lazy").setup({
	spec = { { import = "plugins" } },
	checker = { enabled = false },
	change_detection = { notify = false },
	ui = {
		title = " 󰒲 lazy.nvim ",
		size = { width = 0.8, height = 0.8 },
		border = "none",
		wrap = false,
		install = { colorscheme = { "default" } },
		icons = require("stuff.icons").lazy,
		style = "minimal",
	},
	git = { timeout = 30 },
	rocks = { enabled = false },
})
vim.keymap.set("n", "<Leader>pi", "<CMD>Lazy<CR>", { desc = "Lazy" })
