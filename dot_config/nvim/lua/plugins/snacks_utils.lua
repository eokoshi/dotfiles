local M = {}
local Snacks = require("snacks")

---@param opts? snacks.toggle.Config
function M.toggle_virtual_text(opts)
	return Snacks.toggle.new({
		id = "virtual_text",
		name = "virtual text",
		get = function() return vim.diagnostic.config().virtual_text end,
		set = function(state) vim.diagnostic.config({ virtual_text = state }) end,
	}, opts)
end

function M.toggle_virtual_lines(opts)
	return Snacks.toggle.new({
		id = "virtual_lines",
		name = "virtual lines",
		get = function() return vim.diagnostic.config().virtual_lines end,
		set = function(state) vim.diagnostic.config({ virtual_lines = state }) end,
	}, opts)
end

-- Toggle autosave for current buffer
function M.toggle_autosave(opts)
	return Snacks.toggle.new({
		id = "autosave",
		name = "autosave",
		get = function() return vim.b.autosave end,
		set = function(state)
			local bufnr = vim.api.nvim_get_current_buf()
			if state then
				local group = vim.api.nvim_create_augroup("AutoSaveBuffer" .. bufnr, { clear = true })
				vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
					group = group,
					buffer = bufnr,
					callback = function()
						if vim.b.autosave and vim.bo.modifiable and vim.bo.modified then vim.cmd("silent write") end
					end,
				})
			else
				vim.cmd("autocmd! AutoSaveBuffer" .. bufnr)
			end
			vim.b.autosave = state
		end,
	}, opts)
end

function M.toggle_formatting(opts)
	return Snacks.toggle.new({
		id = "formatting",
		name = "formatting",
		get = function() return vim.b.autoformat or vim.b.autoformat == nil end,
		set = function(state) vim.b.autoformat = state end,
	}, opts)
end

function M.toggle_completion(opts)
	return Snacks.toggle.new({
		id = "completion",
		name = "completion",
		get = function() return vim.b.completion or vim.b.completion == nil end,
		set = function(state) vim.b.completion = state end,
	}, opts)
end

function M.toggle_math_virt(opts)
	return Snacks.toggle.new({
		id = "math_virt",
		name = "math virtual text",
		get = function()
			local bufnr = vim.api.nvim_get_current_buf()
			return require("nabla").is_virt_enabled(bufnr)
		end,
		set = function() require("nabla").toggle_virt({ autogen = "true", silent = "true" }) end,
	}, opts)
end

function M.pick_config_chezmoi()
	if vim.fn.has("win32") == 1 then
		vim.notify("Do not mess with config from Windows", vim.log.levels.ERROR)
	else
		Snacks.picker.files({
			hidden = true,
			ignored = true,
			follow = true,
			dirs = { os.getenv("HOME") .. "/.local/share/chezmoi" },
		})
	end
end

function M.pick_icon()
	require("snacks.picker").icons({
		custom_sources = { unicode = vim.fn.stdpath("config") .. "/unicode_chars.json" },
	})
end

return M
