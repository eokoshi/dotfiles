return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		version = "*",
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
	{
		"igorlfs/nvim-dap-view",
		---@module 'dap-view'
		---@type dapview.Config
		opts = {},
	},
}
