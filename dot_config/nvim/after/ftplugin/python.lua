-- Python keymaps
local map = require("stuff.functions").map
map("n", "<Leader>fi", "?import<CR>", { desc = "Jump to imports", buffer = true })
map("v", "gd", ":norm ysaw'f=r:A,<CR>gv<Plug>(nvim-surround-visual-line)}iargs = <ESC>va{o^", { desc = "Convert lines to dict", buffer = true })
