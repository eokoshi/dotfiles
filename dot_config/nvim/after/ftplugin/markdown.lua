-- Options
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2

-- Markdown keymaps
local map = require("stuff.functions").map
map("n", "<Leader>m", "", { desc = "Markdown", buffer = true })
map("n", "<Leader>mm", "<CMD>lua require('nabla').popup({border = 'solid'})<CR>", { desc = "Show math popup", buffer = true })
map("n", "<Leader>mt", "<CMD>Obsidian today<CR>", { desc = "today's note", buffer = true })
map("n", "<Leader>my", "<CMD>Obsidian yesterday<CR>", { desc = "yesterday's note", buffer = true })
map("n", "<Leader>mf", "<CMD>Obsidian dailies -48 0<CR>", { desc = "find daily notes", buffer = true })
map("n", "<Leader>mn", "<CMD>Obsidian new_from_template<CR>", { desc = "new from template", buffer = true })
