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
			map("n", "<F5>", function()
				require("dap").continue()
			end, { desc = "Debugger: Start" })
			map("n", "<F17>", function()
				require("dap").terminate()
			end, { desc = "Debugger: Stop" }) -- Shift+F5
			map("n", "<F29>", function()
				require("dap").restart_frame()
			end, { desc = "Debugger: Restart" }) -- Control+F5
			map("n", "<F6>", function()
				require("dap").pause()
			end, { desc = "Debugger: Pause" })
			map("n", "<F9>", function()
				require("dap").toggle_breakpoint()
			end, { desc = "Debugger: Toggle Breakpoint" })
			map("n", "<F10>", function()
				require("dap").step_over()
			end, { desc = "Debugger: Step Over" })
			map("n", "<F11>", function()
				require("dap").step_into()
			end, { desc = "Debugger: Step Into" })
			map("n", "<F23>", function()
				require("dap").step_out()
			end, { desc = "Debugger: Step Out" }) -- Shift+F11
			map("n", "<Leader>db", function()
				require("dap").toggle_breakpoint()
			end, { desc = "Toggle Breakpoint (F9)" })
			map("n", "<Leader>dB", function()
				require("dap").clear_breakpoints()
			end, { desc = "Clear Breakpoints" })
			map("n", "<Leader>dc", function()
				require("dap").continue()
			end, { desc = "Start/Continue (F5)" })
			map("n", "<Leader>dh", function()
				require("dap.ui.widgets").hover()
			end, { desc = "Debugger Hover" })
			map("n", "<Leader>di", function()
				require("dap").step_into()
			end, { desc = "Step Into (F11)" })
			map(
				"n",
				"<Leader>dj",
				"<CMD>e $PWD/.vscode/launch.json<CR><CMD>w ++p<CR>",
				{ desc = "Open workspace DAP config" }
			)
			map("n", "<Leader>do", function()
				require("dap").step_over()
			end, { desc = "Step Over (F10)" })
			map("n", "<Leader>dO", function()
				require("dap").step_out()
			end, { desc = "Step Out (S-F11)" })
			map("n", "<Leader>dp", function()
				require("dap").pause()
			end, { desc = "Pause (F6)" })
			map("n", "<Leader>dq", function()
				require("dap").close()
			end, { desc = "Close Session" })
			map("n", "<Leader>dQ", function()
				require("dap").terminate()
			end, { desc = "Terminate Session (S-F5)" })
			map("n", "<Leader>dr", function()
				require("dap").restart_frame()
			end, { desc = "Restart (C-F5)" })
			map("n", "<Leader>dR", function()
				require("dap").repl.toggle()
			end, { desc = "Toggle REPL" })
			map("n", "<Leader>ds", function()
				require("dap").run_to_cursor()
			end, { desc = "Run To Cursor" })
			map("n", "<F21>", function()
				vim.ui.input({ prompt = "Condition: " }, function(condition)
					if condition then
						require("dap").set_breakpoint(condition)
					end
				end)
			end, { desc = "Debugger: Conditional Breakpoint" }) -- Shift+F9
			map("n", "<Leader>dC", function()
				vim.ui.input({ prompt = "Condition: " }, function(condition)
					if condition then
						require("dap").set_breakpoint(condition)
					end
				end)
			end, { desc = "Conditional Breakpoint (S-F9)" })
			-- map("v", "<Leader>dE", function() require("dapui").eval() end, {desc = "Evaluate Input" })
			-- map("n", "<Leader>du", function() require("dapui").toggle() end, {desc = "Toggle Debugger UI" })
			map("n", "<Leader>dE", function()
				vim.ui.input({ prompt = "Expression: " }, function(expr)
					if expr then
						require("dapui").eval(expr, { enter = true })
					end
				end)
			end, { desc = "Evaluate Input" })
			map("n", "<Leader>du", function()
				require("dap-view").toggle(true)
			end, { desc = "Toggle Debugger UI" })
		end,
	},
}
