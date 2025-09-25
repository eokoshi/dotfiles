local icons = require("stuff.icons")

local function get_attached_clients()
	local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
	if #buf_clients == 0 then
		return ""
	end

	local buf_ft = vim.bo.filetype
	local buf_client_names = {}

	-- add client
	for _, client in pairs(buf_clients) do
		if client.name ~= "copilot" and client.name ~= "null-ls" and client.name ~= "render-markdown" then
			table.insert(buf_client_names, client.name)
		end
	end

	-- Add sources (from null-ls)
	-- null-ls registers each source as a separate attached client, so we need to filter for unique names down below.
	local null_ls_s, null_ls = pcall(require, "null-ls")
	if null_ls_s then
		local sources = null_ls.get_sources()
		for _, source in ipairs(sources) do
			if source._validated then
				for ft_name, ft_active in pairs(source.filetypes) do
					if ft_name == buf_ft and ft_active then
						table.insert(buf_client_names, source.name)
					end
				end
			end
		end
	end
	-- This needs to be a string only table so we can use concat below
	local unique_client_names = {}
	for _, client_name_target in ipairs(buf_client_names) do
		local is_duplicate = false
		for _, client_name_compare in ipairs(unique_client_names) do
			if client_name_target == client_name_compare then
				is_duplicate = true
			end
		end
		if not is_duplicate then
			table.insert(unique_client_names, client_name_target)
		end
	end

	local icon = icons.lualine.lsp
	local separator = ", "

	local client_names_str = table.concat(unique_client_names, separator)
	local language_servers = string.format("%s", client_names_str)
	local string_out = icon .. " " .. language_servers

	return string_out
end

return {
	{
		"eokoshi/lualine.nvim",
		lazy = false,
		opts = {
			options = {
				theme = "auto",
				component_separators = "",
				section_separators = { left = icons.lualine.rsep, right = icons.lualine.lsep },
				globalstatus = true,
				disabled_filetypes = {
					statusline = { "snacks_dashboard", "undotree" },
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
						path = 4,
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
						"codecompanion",
						color = "lualine_c_diagnostics_error_insert",
					},
					{
						get_attached_clients,
						cond = vim.lsp.buf_is_attached,
					},
				},
				lualine_y = {
					{ "fileformat", padding = { left = 0, right = 0 } },
					"hostname",
				},
				lualine_z = {
					-- {
					-- 	"location",
					-- 	padding = 1,
					-- 	separator = { right = "" },
					-- 	cond = function()
					-- 		if vim.o.filetype == "codecompanion" then
					-- 			return false
					-- 		else
					-- 			return true
					-- 		end
					-- 	end,
					-- },
				},
			},
			tabline = {
				lualine_a = {
					{
						"buffers",
						mode = 4,
						hide_filename_extension = true,
						symbols = {
							alternate_file = icons.lualine.alternate .. " ",
							modified = " " .. icons.lualine.modified,
						},
						filetype_names = {
							snacks_picker_list = icons.filetype.snacks_picker_list,
							["dap-view-term"] = icons.debug.bug,
						},
						use_mode_colors = true,
						-- cond = function()
						-- 	if vim.fn.expand("%") == "" then
						-- 		return false
						-- 	else
						-- 		return true
						-- 	end
						-- end,
					},
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {
					{
						"tabs",
						use_mode_colors = true,
						show_modified_status = false,
					},
				},
				lualine_z = {},
			},
		},
	},
}
