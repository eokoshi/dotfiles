local icons = require("stuff.icons")
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

-- when using null-ls, get the names of those formatters as well
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
