local icons = require("stuff.icons")

vim.o.autoread = true
-- vim.o.clipboard = "unnamedplus"
vim.o.conceallevel = 2
vim.o.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.diffopt = { "internal", "closeoff", "filler", "hiddenoff", "linematch:60" }
vim.o.expandtab = false -- Use spaces instead of tabs when true
vim.opt.fileencodings = { "ucs-bom", "utf-8", "default", "cp932", "latin1" }
vim.opt.fillchars = {
	foldopen = icons.folds.foldopen,
	foldclose = icons.folds.foldclose,
	fold = icons.folds.foldline_fill,
	foldsep = icons.folds.foldsep,
	eob = " ",
}
vim.o.foldcolumn = "1"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client ~= nil and client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})
vim.o.foldlevelstart = 99
vim.o.foldtext = vim.lsp.foldtext()
vim.o.formatoptions = "lnjq"
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.linebreak = true -- Wrap lines at convenient points
vim.opt.listchars = { space = "␠", tab = "_" }
vim.o.number = true
vim.o.numberwidth = 2
vim.o.relativenumber = false
vim.o.scrolloff = 10 -- Lines of context
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "folds", "options", "resize" }
vim.o.shell = "/bin/bash"
vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = 0 -- Size of an indent, 0 to inherit from tabstop
vim.o.shortmess = "aoOsIcCF"
vim.o.showbreak = "⇢ "
vim.o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.o.sidescrolloff = 8 -- Columns of context
vim.o.smartcase = true -- Don't ignore case with capitals
vim.o.smartindent = false -- Insert indents automatically (messes with python treesitter, so leave false)
vim.o.spelllang = "en_us,medical"
vim.o.spellcapcheck = ""
vim.o.splitkeep = "screen"
vim.o.splitbelow = true -- Put new windows below current
vim.o.splitright = true -- Put new windows right of current
vim.o.swapfile = true
vim.o.tabstop = 2 -- Number of spaces tabs count for
vim.o.termguicolors = true
vim.o.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
vim.o.undofile = true
vim.o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.o.winborder = "rounded"
vim.o.winminwidth = 20 -- Minimum window width
vim.o.wrap = false -- Disable line wrap

-- UI
vim.o.cursorline = true -- Enable highlighting of the current line
vim.o.colorcolumn = "+1"
vim.o.ruler = false -- Disable the default ruler
vim.o.showmode = false -- Dont show mode since we have a statusline

-- Built-in Completion
-- vim.o.autocomplete = true
-- vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- vim.o.wildmode = "longest:full,full" -- Command-line completion mode

-- diagnostic options
vim.diagnostic.config({
	virtual_text = true,
	float = {
		border = "single",
		source = true,
	},
	signs = { text = { icons.diagnostic.error, icons.diagnostic.warn, icons.diagnostic.info, icons.diagnostic.hint } },
	severity_sort = true,
})
