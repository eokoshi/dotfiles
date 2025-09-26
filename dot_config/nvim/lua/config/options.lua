local icons = require("stuff.icons")

vim.o.autowrite = true -- Enable auto write
vim.o.clipboard = "unnamedplus" -- Sync with system clipboard
vim.o.colorcolumn = "+1"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.o.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.o.confirm = true -- Confirm to save changes before exiting modified buffer
vim.o.cursorline = true -- Enable highlighting of the current line
vim.opt.diffopt = { "internal", "closeoff", "filler", "hiddenoff", "linematch:60" }
vim.o.expandtab = false -- Use spaces instead of tabs when true
vim.opt.fillchars = {
	foldopen = icons.folds.foldopen,
	foldclose = icons.folds.foldclose,
	fold = icons.folds.foldline_fill,
	foldsep = icons.folds.foldsep,
	eob = " ",
}
vim.o.findfunc = "fd"
vim.o.foldcolumn = "1"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})
vim.o.foldlevelstart = 99
vim.o.foldtext = vim.lsp.foldtext()
vim.o.formatoptions = "lnjq"
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.grepprg = "rg --vimgrep"
vim.o.hlsearch = true
vim.o.ignorecase = true -- Ignore case
vim.o.incsearch = true
vim.o.inccommand = "nosplit" -- preview incremental substitute
vim.o.incsearch = true
vim.o.jumpoptions = "view"
vim.o.laststatus = 3 -- global statusline
vim.o.linebreak = true -- Wrap lines at convenient points
vim.o.list = false -- Show some invisible characters (tabs...
vim.o.mouse = "a" -- Enable mouse mode
vim.o.number = true
vim.o.numberwidth = 2
vim.o.pumblend = 10 -- Popup blend
vim.o.pumheight = 10 -- Maximum number of entries in a popup
vim.o.relativenumber = true
vim.o.ruler = false -- Disable the default ruler
vim.o.scrolloff = 10 -- Lines of context
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = 0 -- Size of an indent, 0 to inherit from tabstop
vim.o.shortmess = "aoOsIcCF"
vim.o.showmode = false -- Dont show mode since we have a statusline
vim.o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.o.sidescrolloff = 8 -- Columns of context
vim.o.smartcase = true -- Don't ignore case with capitals
vim.o.smartindent = false -- Insert indents automatically (messes with python treesitter, so leave false)
vim.o.smoothscroll = true
vim.o.softtabstop = 0
vim.o.spelllang = "en"
vim.o.splitkeep = "screen"
vim.o.splitbelow = true -- Put new windows below current
vim.o.splitright = true -- Put new windows right of current
vim.o.swapfile = true
vim.o.tabstop = 4 -- Number of spaces tabs count for
vim.o.termguicolors = true -- True color support
vim.o.textwidth = 98
vim.o.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 200 -- Save swap file and trigger CursorHold
vim.o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.o.wildmode = "longest:full,full" -- Command-line completion mode
vim.o.winborder = "solid"
vim.o.winminwidth = 20 -- Minimum window width
vim.o.wrap = false -- Disable line wrap

-- System features
if vim.fn.has("win32") == 1 then
	vim.o.shell = "~/scoop/shims/pwsh.exe"
	vim.o.shellcmdflag =
		"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
	vim.o.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
	vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
else
	vim.o.shell = "/usr/bin/env bash"
end

-- diagnostic options
vim.diagnostic.config({
	virtual_text = true,
	float = {
		border = "single",
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
