-- if true then return {} end

return {
	-- scrollbar issue
	"Kayzels/noice.nvim",
	branch = "fix-scrollbar",
	commit = "43c79b8",

	-- "folke/noice.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	event = "VeryLazy",
	opts = {
		presets = {
			bottom_search = true,
			lsp_doc_border = true,
			-- command_palette = true, -- does not work with blink cmdline completions
		},
		views = {
			split = {
				enter = false,
				size = "auto",
			},
			popup = {
				size = "auto",
			},
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
						{ find = "%d+ lines" },
						{ find = "%d+ fewer" },
						{ find = "is deprecated" },
					},
				},
				view = "mini",
			},
			{
				filter = {
					event = "msg_show",
					kind = "lua_print",
					find = "[nvim-treesitter]",
				},
				view = "mini",
			},
			{ -- send long messages to view
				filter = {
					event = "msg_show",
					min_height = 20,
					cmdline = false,
				},
				view = "split",
			},
			{ -- send cmdline outputs to popup
				filter = {
					event = "msg_show",
					min_height = 5,
					cmdline = true,
				},
				view = "popup",
			},
		},
		lsp = {
			override = {
				["vim.lsp.util.stylize_markdown"] = false,
				["cmp.entry.get_documentation"] = false,
			},
		},
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
		},
		popupmenu = {
			enabled = true,
		},
	},
	config = function(_, opts)
		require("noice").setup(opts)

		-- lualine position errors
		local NoiceUser = vim.api.nvim_create_augroup("NoiceUser", { clear = true })
		vim.api.nvim_create_autocmd("BufEnter", {
			group = NoiceUser,
			callback = function()
				if vim.o.filetype ~= "snacks_dashboard" and vim.o.buftype ~= "nofile" then
					require("noice").setup(opts)
				end
			end,
			desc = "Reload Noice",
		})
	end,
}
