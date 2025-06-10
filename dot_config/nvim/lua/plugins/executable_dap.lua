return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"mfussenegger/nvim-dap",
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
	-- {
	-- 	"rcarriga/nvim-dap-ui",
	-- 	dependencies = {
	-- 		"mfussenegger/nvim-dap",
	-- 		"nvim-neotest/nvim-nio",
	-- 	},
	-- },
	-- {
	-- 	"rcarriga/cmp-dap",
	-- 	lazy = true,
	-- 	config = function(...)
	-- 		return function(_, _)
	-- 			local blink_avail, blink = pcall(require, "blink.cmp")
	-- 			if blink_avail then
	-- 				for _, dap_ft in ipairs({ "dap-repl", "dapui_watches", "dapui_hover" }) do
	-- 					blink.add_filetype_source(dap_ft, "dap")
	-- 				end
	-- 			end
	-- 		end
	-- 	end,
	-- 	specs = {
	-- 		{
	-- 			"Saghen/blink.cmp",
	-- 			optional = true,
	-- 			specs = { "Saghen/blink.compat", lazy = true, opts = {} },
	-- 			opts = {
	-- 				sources = {
	-- 					providers = {
	-- 						dap = {
	-- 							name = "dap",
	-- 							module = "blink.compat.source",
	-- 							score_offset = 100,
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },
}
