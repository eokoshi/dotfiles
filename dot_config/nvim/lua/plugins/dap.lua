return {
	{
		"mfussenegger/nvim-dap-python",
		ft = { "python" },
		dependencies = {
			{ "mfussenegger/nvim-dap" },
			{
				"igorlfs/nvim-dap-view",
				---@module 'dap-view'
				---@type dapview.Config
				opts = {
					winbar = {
						controls = {
							enabled = true,
						},
						sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
						default_section = "scopes",
					},
					windows = {
						height = 0.25,
						position = "below",
						terminal = {
							width = 0.5,
							position = "left",
							start_hidden = true,
						},
					},
					auto_toggle = true,
				},
			},
		},
		config = function()
			require("dap-python").setup("uv")
			local dap = require("dap")
			dap.defaults.fallback.stepping_granularity = "line"
			dap.defaults.fallback.auto_continue_if_many_stopped = false
		end,
	},
}
