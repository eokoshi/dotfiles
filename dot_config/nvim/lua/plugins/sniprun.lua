if vim.fn.has("linux") == 1 then
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("SnipRun", { clear = true }),
		pattern = { "python" },
		callback = function()
			local map = require("stuff.functions").map
			map("n", "<Leader>r", "", { desc = "Run Code", buffer = true })
			map("n", "<CR>", "<CMD>SnipRun<CR>", { desc = "Run line", buffer = true })
			map("v", "<CR>", ":SnipRun<CR>", { desc = "Run selection", buffer = true })
			map("n", "<Leader>rc", "<CMD>SnipClose<CR>", { desc = "Close REPL", buffer = true })
			map("n", "<Leader>rl", "<CMD>SnipRun<CR>", { desc = "Run line", buffer = true })
			map("n", "<Leader>rf", "<CMD>%SnipRun<CR>", { desc = "Run file", buffer = true })
			map("n", "<Leader>rR", "<CMD>SnipReset<CR>", { desc = "Reset REPL", buffer = true })
			map("n", "<Leader>rb", function()
				vim.api.nvim_feedkeys("vggo", "n", false)
				vim.cmd("SnipRun")
				vim.cmd("normal!")
			end, { desc = "Run above", buffer = true })
			map("n", "<Leader>r<Space>", function()
				vim.api.nvim_feedkeys("vaj", "n", false)
				vim.cmd("SnipRun")
				vim.cmd("normal!")
			end, { desc = "Run cell", buffer = true })
		end,
	})
	return {
		"michaelb/sniprun",
		branch = "master",
		build = "bash install.sh 1",
		opts = {
			selected_interpreters = { "Python3_fifo" },
			repl_enable = { "Python3_fifo" },
			display = {
				"Terminal",
			},
			display_options = {
				terminal_position = "horizontal",
			},
		},
	}
else
	return {}
end
