return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	version = "*",
	opts = {
		options = {
			themable = true,
			-- separator_style = "slope",
			diagnostics = "nvim_lsp",
			show_tab_indicators = true,
			offsets = {
				{
					filetype = "neo-tree",
					text = "",
					highlight = "BufferLineTab",
					separator = true,
				},
			},
			show_buffer_close_icons = false,
			tab_size = 10,
		},
	},
	init = function()
		local map = require("stuff.functions").map
		map("n", "<leader>bb", "<CMD>BufferLinePick<CR>", { desc = "Pick buffer" })
		map("n", "<leader>bx", "<CMD>BufferLinePickClose<CR>", { desc = "Pick buffer to close" })
	end,
}
