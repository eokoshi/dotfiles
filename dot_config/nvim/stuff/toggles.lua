local M = {}
local Snacks = require("snacks")

---@param opts? snacks.toggle.Config
function M.virtual_text(opts)
	return Snacks.toggle.new({
		id = "virtual_text",
		name = "virtual text",
		get = function()
			return vim.diagnostic.config().virtual_text
		end,
		set = function(state)
			vim.diagnostic.config({ virtual_text = state })
		end,
	}, opts)
end

function M.virtual_lines(opts)
	return Snacks.toggle.new({
		id = "virtual_lines",
		name = "virtual lines",
		get = function()
			return vim.diagnostic.config().virtual_lines
		end,
		set = function(state)
			vim.diagnostic.config({ virtual_lines = state })
		end,
	}, opts)
end

function M.autosave(opts)
	return Snacks.toggle.new({
		id = "autosave",
		name = "autosave",
		get = function()
			if vim.b["autosave_enabled"] then
				return true
			else
				return false
			end
		end,
		set = function()
			require("stuff.functions").ToggleBufferAutoSave()
		end,
	}, opts)
end

function M.math_virt(opts)
	return Snacks.toggle.new({
		id = "math_virt",
		name = "math virtual text",
		get = function()
			local bufnr = vim.api.nvim_get_current_buf()
			local state = require("nabla").is_virt_enabled(bufnr)
			return state
		end,
		set = function()
			require("nabla").toggle_virt({ autogen = "true", silent = "true" })
		end,
	}, opts)
end

return M
