local icons = require("stuff.icons")

-- EDITING
vim.o.confirm = true -- Confirm to save changes before exiting modified buffer
vim.o.formatoptions = "lnjq"
vim.o.expandtab = false -- Use spaces instead of tabs when true
vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = 0 -- Size of an indent, 0 to inherit from tabstop
vim.o.tabstop = 2 -- Number of spaces tabs count for
vim.go.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode

-- UI
vim.o.cmdheight = 0
vim.go.conceallevel = 2
vim.go.cursorline = true -- Enable highlighting of the current line
vim.go.colorcolumn = "+1"
vim.go.foldcolumn = "1"
vim.o.hlsearch = true
vim.o.incsearch = true
vim.opt_global.listchars = { space = "␠", tab = "_" }
vim.go.number = true
vim.go.numberwidth = 2
vim.go.relativenumber = false
vim.go.ruler = false -- Disable the default ruler
vim.go.scrolloff = 10 -- Lines of context
vim.o.shortmess = "aoOsIcCF"
vim.go.showmode = false -- Dont show mode since we have a statusline
vim.go.sidescrolloff = 8 -- Columns of context
vim.go.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.o.splitkeep = "screen"
vim.o.splitbelow = true -- Put new windows below current
vim.o.splitright = true -- Put new windows right of current
vim.o.winborder = "rounded"
vim.o.winminwidth = 20 -- Minimum window width
vim.go.wrap = false -- Disable line wrap
vim.opt_global.fillchars = {
	foldopen = icons.folds.foldopen,
	foldclose = icons.folds.foldclose,
	fold = icons.folds.foldline_fill,
	foldsep = icons.folds.foldsep,
	eob = " ",
}
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

-- Misc
vim.o.ignorecase = true
vim.o.smartcase = true -- Don't ignore case with capitals
vim.opt.diffopt = { "internal", "closeoff", "filler", "hiddenoff", "linematch:60" }
vim.opt.fileencodings = { "ucs-bom", "utf-8", "default", "cp932", "latin1" }
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "folds", "resize" }
vim.o.swapfile = true
vim.o.undofile = true
vim.o.spelllang = "en_us,medical"
vim.o.termguicolors = true
vim.o.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key

-- folding
vim.go.foldmethod = "expr"
vim.go.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevelstart = 99
vim.o.foldtext = vim.lsp.foldtext()
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client ~= nil and client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})

-- line wrapping
vim.go.breakindent = true
vim.go.breakindentopt = "list:-1"
vim.o.formatlistpat = "^\\s*\\d\\+[\\.\\,\\)\\]\\}] \\|^\\s*[\\-\\*] "
vim.go.linebreak = true -- Wrap lines at convenient points
vim.go.showbreak = "> "

-- Built-in Completion
-- vim.o.autocomplete = true
-- vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- vim.o.wildmode = "longest:full,full" -- Command-line completion mode

-- diagnostics
vim.diagnostic.config({
	virtual_text = true,
	float = {
		border = "single",
		source = true,
	},
	signs = { text = { icons.diagnostic.error, icons.diagnostic.warn, icons.diagnostic.info, icons.diagnostic.hint } },
	severity_sort = true,
})
