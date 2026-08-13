-- Options
vim.opt_local.wrap = true
vim.opt_local.expandtab = true

local toggles = require("stuff.toggles")
local map = require("stuff.functions").map
map("n", "<Leader>m", "", { desc = "Markdown", buffer = true })
map({ "n", "v" }, "<CR>", "<cmd>Checkmate metadata toggle done<CR>", { desc = "Toggle todo item", buffer = true })
map({ "n", "v" }, "<leader>mc", "", { desc = "Checkmate", buffer = true })
map({ "n", "v" }, "<leader>mc+", "<cmd>Checkmate cycle_next<CR>", { desc = "Cycle todo item(s) to the next state", buffer = true })
map({ "n", "v" }, "<leader>mc-", "<cmd>Checkmate cycle_previous<CR>", { desc = "Cycle todo item(s) to the previous state", buffer = true })
map({ "n", "v" }, "<leader>mcn", "<cmd>Checkmate create<CR>", { desc = "Create todo item", buffer = true })
map({ "n", "v" }, "<leader>mcr", "<cmd>Checkmate remove<CR>", { desc = "Remove todo marker (convert to text)", buffer = true })
map({ "n", "v" }, "<leader>mcR", "<cmd>Checkmate remove_all_metadata<CR>", { desc = "Remove all metadata from a todo item", buffer = true })
map("n", "<leader>mca", "<cmd>Checkmate archive<CR>", { desc = "Archive checked/completed todo items (move to bottom section)", buffer = true })
map("n", "<leader>mcv", "<cmd>Checkmate metadata select_value<CR>", { desc = "Update the value of a metadata tag under the cursor", buffer = true })
map("n", "<leader>mc]", "<cmd>Checkmate metadata jump_next<CR>", { desc = "Move cursor to next metadata tag", buffer = true })
map("n", "<leader>mc[", "<cmd>Checkmate metadata jump_previous<CR>", { desc = "Move cursor to previous metadata tag", buffer = true })
map("n", "<Leader>mm", function() require("nabla").popup({ border = "solid" }) end, { desc = "Show math popup", buffer = true })
toggles.math_virt():map("<Leader>mv", { buffer = true })
