vim.o.autoindent = true -- copy indent from current line when starting new line
vim.o.breakindentopt = "list:-1"
vim.o.breakindent = true
vim.o.cmdheight = 0
vim.o.colorcolumn = "+1"
vim.o.conceallevel = 2
vim.o.confirm = true -- Confirm to save changes before exiting modified buffer
vim.o.cursorline = true -- Enable highlighting of the current line
vim.o.diffopt = "internal,closeoff,filler,hiddenoff,linematch:60"
vim.o.expandtab = false -- Use spaces instead of tabs when true
vim.o.fileencodings = "ucs-bom,utf-8,default,cp932,latin1"
vim.o.fillchars = "foldopen:,foldclose:,fold:,foldsep: ,eob: "
vim.go.foldcolumn = "1"
vim.o.foldlevelstart = 99
vim.o.foldmethod = "indent"
vim.o.foldtext = ""
vim.o.formatlistpat = "^\\s*\\d\\+[\\.\\,\\)\\]\\}] \\|^\\s*[\\-\\*] "
vim.o.formatoptions = "lnjq"
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.linebreak = true -- Wrap lines at convenient points
vim.o.listchars = "space:␠,tab:_"
vim.go.number = true
vim.go.numberwidth = 2
vim.o.ruler = false -- Disable the default ruler
vim.o.scrolloff = 10 -- keep n lines above below cursor in view
vim.o.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,folds,resize"
vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = 0 -- Size of an indent, 0 to inherit from tabstop
vim.o.shortmess = "aoOsIcCF"
vim.o.showbreak = "> "
vim.o.showmode = false -- Dont show mode since we have a statusline
vim.o.sidescrolloff = 8 -- Columns of context
vim.o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.o.smartcase = true -- Don't ignore case with capitals
vim.o.spelllang = "en_us,medical"
vim.o.splitbelow = true -- Put new windows below current
vim.o.splitkeep = "screen"
vim.o.splitright = true -- Put new windows right of current
vim.o.swapfile = false
vim.o.tabstop = 2 -- Number of spaces tabs count for
vim.o.undofile = true
vim.o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.o.winborder = "rounded"
vim.o.wrap = false -- Disable line wrap

-- diagnostics
vim.diagnostic.config({
	virtual_text = true,
	float = { border = "single", source = true },
	signs = { text = { "", "", "", "󰌵" } },
	severity_sort = true,
})

require("vim._core.ui2").enable({
	enable = true,
	msg = {
		---@type 'cmd'|'msg' Default message target, either in the cmdline or in a separate ephemeral message window.
		---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target or table mapping |ui-messages| kinds and triggers to a target.
		targets = "msg",
		dialog = { height = 0.5 },
		msg = { height = 0.5, timeout = 4000 },
		pager = { height = 1 },
	},
})
