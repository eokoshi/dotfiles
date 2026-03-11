-- Set leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.autowrite = true -- Enable auto write (this is not the same as autosave)
vim.o.autoread = true
vim.o.colorcolumn = "+1"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.o.confirm = true -- Confirm to save changes before exiting modified buffer
vim.o.cursorline = true -- Enable highlighting of the current line
vim.o.expandtab = false -- Use spaces instead of tabs when true
vim.o.findfunc = "fd"
vim.o.foldmethod = "expr"
vim.o.foldlevelstart = 99
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
vim.o.relativenumber = true
vim.o.ruler = false -- Disable the default ruler
vim.o.scrolloff = 10 -- Lines of context
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = 0 -- Size of an indent, 0 to inherit from tabstop
vim.o.shortmess = "aoOsIcCF"
vim.o.sidescrolloff = 8 -- Columns of context
vim.o.smartcase = true -- Don't ignore case with capitals
vim.o.smartindent = false -- Insert indents automatically (messes with python treesitter, so leave false)
vim.o.smoothscroll = true
vim.o.softtabstop = 0
vim.o.spelllang = "en_us,medical"
vim.o.spellcapcheck = ""
vim.o.splitkeep = "screen"
vim.o.splitbelow = true -- Put new windows below current
vim.o.splitright = true -- Put new windows right of current
vim.o.swapfile = true
vim.o.tabstop = 4 -- Number of spaces tabs count for
vim.o.termguicolors = true -- True color support
vim.o.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 200 -- Save swap file and trigger CursorHold
vim.o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.o.wildmode = "longest:full,full" -- Command-line completion mode
vim.o.winborder = "rounded"
vim.o.winminwidth = 20 -- Minimum window width
vim.o.wrap = false -- Disable line wrap

-- Helper function for VSCode commands
local function vscode_call(cmd)
	return function()
		require("vscode").call(cmd)
	end
end

-- Keybindings
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Navigation: Next/Previous Editor (Tabs)
keymap("n", "]b", vscode_call("workbench.action.nextEditor"), opts)
keymap("n", "[b", vscode_call("workbench.action.previousEditor"), opts)

-- File Management
keymap("n", "<leader>c", vscode_call("workbench.action.closeActiveEditor"), opts)
keymap("n", "<leader>w", vscode_call("workbench.action.files.save"), opts)
keymap("n", "ff", vscode_call("workbench.action.quickOpen"), opts)

-- Close the entire editor group (the split/pane)
keymap("n", "<leader>q", vscode_call("workbench.action.closeEditorsInGroup"), opts)

-- Window Focus (Ctrl-hjkl)
-- These move focus between editor splits and sidebars
keymap("n", "<C-h>", vscode_call("workbench.action.navigateLeft"), opts)
keymap("n", "<C-l>", vscode_call("workbench.action.navigateRight"), opts)

-- Map Backspace to go back to the alternate/previous file
keymap("n", "<BS>", vscode_call("workbench.action.navigateBack"), opts)

-- Toggle Sidebar Visibility (Reliable for closing)
keymap("n", "<leader>e", vscode_call("workbench.action.toggleSidebarVisibility"), opts)
