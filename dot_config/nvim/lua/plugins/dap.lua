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
				handlers = {},
			})
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
					start_hidden = true,
				},
			},
		},
		init = function()
			local dap, dv = require("dap"), require("dap-view")
			local state = require("dap-view.state")
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
				vim.api.nvim_buf_delete(state.term_bufnr, { force = true })
			end
		end,
	},
}
