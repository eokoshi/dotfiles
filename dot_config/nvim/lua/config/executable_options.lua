local icons = require("stuff.icons")

vim.opt.autowrite = true -- Enable auto write
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.opt.colorcolumn = "+1"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = false -- Use spaces instead of tabs
vim.opt.fillchars = {
	foldopen = icons.folds.foldopen,
	foldclose = icons.folds.foldclose,
	fold = icons.folds.foldline_fill,
	foldsep = icons.folds.foldsep,
	eob = " ",
}
vim.opt.findfunc = "fd"
vim.opt.foldmethod = "indent"
vim.opt.formatoptions = "lnjq"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.hlsearch = true
vim.opt.ignorecase = true -- Ignore case
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.incsearch = true
vim.opt.jumpoptions = "view"
vim.opt.laststatus = 3 -- global statusline
vim.opt.linebreak = true -- Wrap lines at convenient points
vim.opt.list = false -- Show some invisible characters (tabs...
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.ruler = false -- Disable the default ruler
vim.opt.scrolloff = 10 -- Lines of context
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.shortmess = "aoOsIcCF"
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.smoothscroll = true
vim.opt.softtabstop = 0
vim.opt.spelllang = { "en" }
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitkeep = "screen"
vim.opt.splitright = true -- Put new windows right of current
vim.opt.swapfile = true
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.textwidth = 98
vim.opt.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winborder = "solid"
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap

-- diagnostic options
vim.diagnostic.config({
	virtual_text = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = { icons.diagnostic.error, icons.diagnostic.warn, icons.diagnostic.info, icons.diagnostic.hint },
	},
	severity_sort = true,
})

-- debugger options
vim.fn.sign_define("DapBreakpoint", { text = icons.debug.breakpoint, texthl = "DiagnosticSignHint" })
vim.fn.sign_define("DapBreakpointCondition", { text = icons.debug.conditional, texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DapLogPoint", { text = icons.debug.logpoint, texthl = "DiagnosticSignOk" })
vim.fn.sign_define("DapStopped", { text = icons.debug.stopped, texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DapBreakpointRejected", { text = icons.debug.rejected, texthl = "DiagnosticSignError" })
