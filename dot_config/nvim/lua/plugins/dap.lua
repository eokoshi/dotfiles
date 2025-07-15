-- if true then return {} end

return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"mfussenegger/nvim-dap",
			"igorlfs/nvim-dap-view",
		},
		config = function()
			require("mason").setup()
			require("mason-nvim-dap").setup({
				handlers = {
					python = function(config)
						local venv_path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
						config.configurations = {
							{
								name = "Launch file",
								type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
								request = "launch",
								program = "${file}", -- This configuration will launch the current file if used.
								python = venv_path and ((vim.fn.has("win32") == 1 and venv_path .. "/Scripts/python") or venv_path .. "/bin/python")
									or nil,
								console = "integratedTerminal",
								cwd = "${workspaceFolder}",
							},
						}
						require("mason-nvim-dap").default_setup(config) -- don't forget this!
					end,
					function(config)
						-- all sources with no handler get passed here
						-- Keep original functionality
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})
			local dap = require("dap")
			dap.defaults.fallback.stepping_granularity = "line"
			dap.defaults.fallback.auto_continue_if_many_stopped = false
		end,
	},
	{
		"igorlfs/nvim-dap-view",
		---@module 'dap-view'
		---@type dapview.Config
		opts = {
			winbar = {
				controls = {
					enabled = true,
				},
			},
			windows = {
				height = 20,
				terminal = {
					position = "right",
					start_hidden = false,
				},
			},
		},
		init = function()
			local dap, dv = require("dap"), require("dap-view")
			dap.listeners.before.attach["dap-view-config"] = function()
				dv.open()
				require("dap-view.term.init").hide_term_buf_win()
				dv.jump_to_view("scopes")
			end
			dap.listeners.before.launch["dap-view-config"] = function()
				dv.open()
				require("dap-view.term.init").hide_term_buf_win()
				dv.jump_to_view("scopes")
			end
			dap.listeners.before.event_terminated["dap-view-config"] = function()
				dv.close(true)
			end
			dap.listeners.before.event_exited["dap-view-config"] = function()
				dv.close(true)
			end
			vim.keymap.set("n", "<Leader>dt", function()
				local state = require("dap-view.state")
				if pcall(vim.api.nvim_win_get_position, state.term_winnr) then
					vim.api.nvim_win_hide(state.term_winnr)
				else
					if vim.o.columns >= 140 then
						state.term_winnr = vim.api.nvim_open_win(
							state.term_bufnrs[state.current_session_id],
							false,
							{ win = vim.api.nvim_list_wins()[1], split = "right", width = 40 }
						)
					else
						state.term_winnr = vim.api.nvim_open_win(
							state.term_bufnrs[state.current_session_id],
							false,
							{ win = state.winnr, split = "above", height = 20 }
						)
					end
				end
			end, { desc = "Toggle console", remap = false, silent = true })
		end,
	},
}
