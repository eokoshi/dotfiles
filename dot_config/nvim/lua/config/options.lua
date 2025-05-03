vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.spell = false
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.scrolloff = 10
vim.opt.colorcolumn = "90"

vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

vim.opt.clipboard = ""

vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"
vim.opt.swapfile = true
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.foldmethod = "indent"
