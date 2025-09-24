return {
	{
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
		end,
	},
}
