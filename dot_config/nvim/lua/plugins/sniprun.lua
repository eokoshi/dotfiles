if vim.fn.has("linux") == 1 then
	return {
		"michaelb/sniprun",
		branch = "master",
		build = "bash install.sh 1",
		opts = {
			selected_interpreters = { "Python3_fifo" },
			repl_enable = { "Python3_fifo" },
			display = {
				"VirtualLine",
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("BufReadPost", {
				group = vim.api.nvim_create_augroup("SnipRun", { clear = true }),
				pattern = "python",
				command = "SnipRun",
			})
			local map = require("stuff.functions").map
			map("n", "<Leader>r", "", { desc = "Run Code" })
			map("n", "<Leader>rc", "<CMD>SnipClose<CR>", { desc = "Close REPL" })
			map("n", "<Leader>rl", "<CMD>SnipRun<CR>", { desc = "Run line" })
			map("n", "<Leader>rf", "<CMD>%SnipRun<CR>", { desc = "Run file" })
			map("n", "<Leader>rr", "vip:SnipRun<CR><ESC>", { desc = "Run scope" })
			map("n", "<Leader>rR", "<CMD>SnipReset<CR>", { desc = "Reset REPL" })
			map("v", "<CR>", ":SnipRun<CR>", { desc = "Run selection" })
		end,
	}
else
	return {}
end
