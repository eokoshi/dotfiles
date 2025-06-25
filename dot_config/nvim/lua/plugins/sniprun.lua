-- if true then return {} end

return {
	{
		"michaelb/sniprun",
		branch = "master",
		build = "bash install.sh 1",
		opts = {
			selected_interpreters = {
				"Python3_fifo",
			},
			repl_enable = {
				"Python3_fifo",
			},
			-- interpreter_options = {
			-- 	Python3_fifo = {
			-- 		venv = { ".venv" },
			-- 	},
			-- },
		},
	},
}
