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
				handlers = {
					function(config)
						-- all sources with no handler get passed here

						-- Keep original functionality
						require("mason-nvim-dap").default_setup(config)
					end,
					python = function(config)
						config.adapters = {
							type = "executable",
							cwd = "${workspaceFolder}",
							python = "${workspaceFolder}/.venv/bin/python",
						}
						require("mason-nvim-dap").default_setup(config) -- don't forget this!
					end,
				},
			})
		end,
	},
	{
		"igorlfs/nvim-dap-view",
		---@module 'dap-view'
		---@type dapview.Config
		opts = {
			controls = {
				enabled = true,
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
			dap.listeners.before.attach["dap-view-config"] = function()
				dv.open()
			end
			dap.listeners.before.launch["dap-view-config"] = function()
				dv.open()
			end
			dap.listeners.before.event_terminated["dap-view-config"] = function()
				dv.close()
			end
			dap.listeners.before.event_exited["dap-view-config"] = function()
				dv.close()
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
