local map = vim.keymap.set
local init_augroup = vim.api.nvim_create_augroup("init", { clear = true })
vim.g.mapleader = " "
vim.g.maplocalleader = "_"

require("autocmds")
require("statusline")

--- Options {{{
vim.o.autoindent = true -- copy indent from current line when starting new line
vim.o.breakindent = true
vim.o.breakindentopt = "list:-1"
vim.o.cmdheight = 0
vim.o.colorcolumn = ""
vim.o.conceallevel = 2
vim.o.confirm = true -- Confirm to save changes before exiting modified buffer
vim.o.cursorline = true -- Enable highlighting of the current line
vim.o.diffopt = "internal,closeoff,filler,hiddenoff,linematch:60"
vim.o.expandtab = false -- Use spaces instead of tabs when true
vim.o.exrc = true
vim.o.fileencodings = "ucs-bom,utf-8,default,cp932,latin1"
vim.o.fillchars = "foldopen:,foldclose:,fold:,foldsep: ,eob: "
vim.o.foldlevelstart = 99
vim.o.foldtext = ""
vim.o.foldmethod = "indent"
vim.o.formatlistpat = "^\\s*\\d\\+[\\.\\,\\)\\]\\}] \\|^\\s*[\\-\\*] "
vim.o.formatoptions = "lnjq"
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.linebreak = true
vim.o.incsearch = true
vim.o.listchars = "space:␠,tab:_,conceal:?,nbsp:+"
vim.o.number = true
vim.o.numberwidth = 2
vim.o.ruler = false -- Disable the default ruler
vim.o.scrolloff = 10 -- keep n lines above below cursor in view
vim.o.smoothscroll = true -- only affects windows with wrap=true, treat wrapped lines as lines when scrolling
vim.o.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,folds,resize"
vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = 0 -- Size of an indent, 0 to inherit from tabstop
vim.o.shortmess = "aoOsIcCF"
vim.o.showcmd = false
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
vim.o.timeoutlen = 500
vim.o.undofile = true
vim.o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.o.winborder = "rounded"
vim.o.wrap = false -- Disable line wrap

-- diagnostics
vim.diagnostic.config({
	virtual_text = true,
	float = { border = "single", source = true },
	signs = { text = { "", "", "", "" } },
	severity_sort = true,
	jump = { on_jump = function() vim.diagnostic.open_float() end },
})

require("vim._core.ui2").enable({
	enable = true,
	msg = {
		---@type 'cmd'|'msg' Default message target, either in the cmdline or in a separate ephemeral message window.
		---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target or table mapping |ui-messages| kinds and triggers to a target.
		target = "msg",
		targets = {
			shell_err = "cmd",
			shell_out = "cmd",
		},
		dialog = { height = 0.5 },
		msg = { height = 0.5, timeout = 4000 },
		pager = { height = 1 },
	},
})
--- }}}

--- Mappings {{{
-- Basic operations
map("n", "<Leader>q", "<CMD>q<CR>", { desc = "Quit window" })
map("n", "<Leader>Q", "<CMD>qa<CR>", { desc = "Quit nvim" })
map("n", "<Leader>w", "<CMD>w<CR>", { desc = "Save buffer" })
map("n", "<Leader>.", "<CMD>cd %:h<CR>", { desc = "cd here" })
map("i", "<S-Tab>", "<C-d>", { desc = "Unindent 1 level" })
map("n", "J", "mzJ`z", { desc = "Shift J without moving cursor" })
map("n", "<BS>", "<C-^>", { desc = "Switch to prev file" })
map("n", "<Leader>x", "<CMD>tabclose<CR>", { desc = "::tabclose" })
map("n", "<Leader>bd", "<CMD>bd!<CR>", { desc = "::bd!" })
map("t", "<ESC><ESC>", "<C-\\><C-n>", { desc = "Escape terminal mode" })
vim.keymap.set("n", "<C-\\>", function() vim.fn.feedkeys("gcc") end)
vim.keymap.set("x", "<C-\\>", function() vim.fn.feedkeys("gc") end)
vim.keymap.set("n", "gK", function() require("functions").keywordprg() end, { desc = "keywordprg" })

-- System clipboard
map("n", "<C-c>", '"+yy', { desc = "Copy line to system clipboard" })
map("x", "<C-c>", '"+y', { desc = "Copy selection to system clipboard" })
map({ "n", "x" }, "<C-v>", '"+p', { desc = "Paste system clipboard" })
map({ "i", "c" }, "<C-v>", "<C-r>+", { desc = "Paste system clipboard" })

-- Movement
map("n", "<C-u>", "<C-u>zz", { desc = "Jump up half page" })
map("n", "<C-d>", "<C-d>zz", { desc = "Jump down half page" })
map("n", "n", "nzzzv", { desc = "Jump to next search result" })
map("n", "N", "Nzzzv", { desc = "Jump to previous search result" })
map("n", "<C-UP>", "<C-y>", { desc = "Scroll up" })
map("n", "<C-DOWN>", "<C-e>", { desc = "Scroll down" })

-- Buffers
map("n", "<Leader>bA", "<CMD>%y+<CR><CR>", { desc = "Copy whole buffer to clipboard" })
map("n", "<Leader>bD", function() require("functions").DOS_to_Unix() end, { desc = "DOS to Unix" })
map("n", "<Leader>bf", function() vim.lsp.buf.format() end, { desc = "format buffer" })
map("n", "<Leader>bz", "<CMD>set foldlevel=2<CR>", { desc = "set foldlevel=2" })

-- LSP
map("n", "<Leader>la", function() vim.lsp.buf.code_action() end, { desc = "code actions" })
map("n", "<Leader>ld", function() vim.diagnostic.open_float() end, { desc = "show diagnostic" })
map("n", "<Leader>lq", function()
	local levels = vim.diagnostic.severity ---@as table
	vim.ui.select(levels, { prompt = "diagnostic level" }, function(choice) vim.diagnostic.setqflist({ severity = choice }) end)
end, { desc = "qflist diagnostics" })
map("n", "<Leader>lr", function() vim.lsp.buf.rename() end, { desc = "rename symbol" })
map("n", "<Leader>lw", function() vim.lsp.buf.workspace_diagnostics() end, { desc = "workspace diagnostics" })
map("n", "<Leader>lw", function() vim.lsp.buf.workspace_diagnostics() end, { desc = "workspace diagnostics" })
map("n", "<Leader>li", "<CMD>checkhealth vim.lsp<CR>", { desc = "LSP info" })
map("n", "gco", "o<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment below" })
map("n", "gcO", "O<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment above" })
map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "go to definition" })
map("n", "gD", function() vim.lsp.buf.type_definition() end, { desc = "go to type definition" })
map("n", "gO", function() vim.lsp.buf.document_symbol({ loclist = false }) end, { desc = "document_symbol" })

--- Highlights {{{
vim.api.nvim_create_autocmd("ColorScheme", {
	group = init_augroup,
	callback = function()
		vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { italic = true, bold = true })
		vim.api.nvim_set_hl(0, "MatchParen", { link = "Error" })
		vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
		vim.api.nvim_set_hl(0, "FloatBorder", { link = "Changed" })
		vim.api.nvim_set_hl(0, "FloatTitle", { link = "Changed" })
	end,
})
--- }}}

-- Packages
map("n", "<leader>pu", function() vim.pack.update() end, { desc = "vim.pack.update()" })
map("n", "<leader>pi", function() vim.pack.update(nil, { offline = true }) end, { desc = "[offline] vim.pack.update()" })
map("n", "<leader>pp", "<CMD>source $MYVIMRC<CR>", { desc = "source config" })
map("n", "<leader>pz", "<CMD>edit $MYVIMRC<CR>", { desc = "edit ~/.config/nvim/init.lua" })

vim.cmd("packadd nvim.undotree")
vim.cmd("packadd cfilter")
--- }}}

--- Custom Filetypes {{{
vim.filetype.add({
	filename = {
		["dot_bashrc"] = "bash",
	},
	pattern = {
		["compose.*%.ya?ml"] = "yaml.docker-compose",
		["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
	},
	extension = {
		tmpl = "gotmpl",
		age = "age",
	},
})
--- }}}

if vim.fn.has("win32") == 1 then
	require("windows")
elseif vim.fn.has("linux") == 1 then
	require("linux")
end

if vim.g.neovide then require("neovide") end

-- vim: set foldmethod=marker
