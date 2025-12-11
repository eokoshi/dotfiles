local icons = require("stuff.icons")

return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	opts = function()
		local codecompanion = require("lualine.component"):extend()
		codecompanion.processing = false
		codecompanion.spinner_index = 1
		local spinner_symbols = {
			"󰍥 ⠋",
			"󰍥 ⠙",
			"󰍥 ⠹",
			"󰍥 ⠸",
			"󰍥 ⠼",
			"󰍥 ⠴",
			"󰍥 ⠦",
			"󰍥 ⠧",
			"󰍥 ⠇",
			"󰍥 ⠏",
		}
		local spinner_symbols_len = 10
		-- Initializer
		function codecompanion:init(options)
			codecompanion.super.init(self, options)

			local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "CodeCompanionRequest*",
				group = group,
				callback = function(request)
					if request.match == "CodeCompanionRequestStarted" then
						self.processing = true
					elseif request.match == "CodeCompanionRequestFinished" then
						self.processing = false
					end
				end,
			})
		end
		-- Function that runs every time statusline is updated
		function codecompanion:update_status()
			if self.processing then
				self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
				return spinner_symbols[self.spinner_index]
			else
				return nil
			end
		end

		-- local trouble = require("trouble").statusline({
		-- 	mode = "lsp_document_symbols",
		-- 	groups = {},
		-- 	title = false,
		-- 	filter = { range = true },
		-- 	format = "{kind_icon}{symbol.name:BufferInactiveSign}",
		-- 	hl_group = "lualine_x_normal",
		-- })

		return {
			options = {
				theme = "auto",
				component_separators = "",
				section_separators = { left = icons.lualine.rsep, right = icons.lualine.lsep },
				globalstatus = true,
				disabled_filetypes = {
					{ "snacks_dashboard" },
				},
			},
			sections = {
				lualine_a = { { "mode", separator = { left = icons.lualine.lsep }, right_padding = 2 } },
				lualine_b = { "branch" },
				lualine_c = {
					{
						"filetype",
						padding = { left = 1, right = 0 },
						icon_only = true,
					},
					{
						"filename",
						path = 1,
						symbols = {
							modified = icons.lualine.modified,
							readonly = icons.lualine.readonly,
							unnamed = icons.lualine.unnamed,
							newfile = icons.lualine.newfile,
						},
						padding = 0,
					},
					{
						"diff",
						symbols = {
							added = icons.git.added .. " ",
							modified = icons.git.modified .. " ",
							removed = icons.git.removed .. " ",
						},
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
						diff_color = {
							-- Same color values as the general color option can be used here.
							added = "GitSignsStagedAdd", -- Changes the diff's added color
							modified = "GitSignsStagedChange", -- Changes the diff's modified color
							removed = "GitSignsStagedDelete", -- Changes the diff's removed color you
						},
					},
					"diagnostics",
					{
						require("noice").api.status.mode.get,
						cond = require("noice").api.status.mode.has,
						color = "lualine_c_diagnostics_error_insert",
					},
				},
				lualine_x = {
					{
						codecompanion,
						color = "lualine_c_diagnostics_error_insert",
					},
					{
						"lsp_status",
						icon = icons.lualine.lsp,
						symbols = {
							done = "",
							separator = " ",
						},
					},
				},
				lualine_y = {
					{ "fileformat", padding = { left = 0, right = 0 } },
					"location",
				},
				lualine_z = {
					{
						"progress",
					},
				},
			},
			-- tabline = {
			-- 	lualine_a = {
			-- 		{
			-- 			"buffers",
			-- 			mode = 4,
			-- 			hide_filename_extension = true,
			-- 			symbols = {
			-- 				alternate_file = icons.lualine.alternate .. " ",
			-- 				modified = " " .. icons.lualine.modified,
			-- 			},
			-- 			filetype_names = {
			-- 				snacks_picker_list = icons.filetype.snacks_picker_list,
			-- 				["dap-view-term"] = icons.debug.bug,
			-- 			},
			-- 			use_mode_colors = true,
			-- 			-- cond = function()
			-- 			-- 	if vim.fn.expand("%") == "" then
			-- 			-- 		return false
			-- 			-- 	else
			-- 			-- 		return true
			-- 			-- 	end
			-- 			-- end,
			-- 		},
			-- 	},
			-- 	lualine_b = {},
			-- 	lualine_c = {},
			-- 	lualine_x = {
			-- 		{
			-- 			trouble.get,
			-- 			cond = trouble.has,
			-- 		},
			-- 	},
			-- 	lualine_y = {
			-- 		{
			-- 			"tabs",
			-- 			use_mode_colors = true,
			-- 			show_modified_status = false,
			-- 		},
			-- 	},
			-- 	lualine_z = {},
			-- },
		}
	end,
}
