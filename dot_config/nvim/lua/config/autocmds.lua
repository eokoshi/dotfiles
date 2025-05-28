-- General Settings
local general = vim.api.nvim_create_augroup("General", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
	group = general,
	desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		-- Disable comment on new line
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	group = general,
	desc = "Disable New Line Comment",
})

vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		vim.cmd("checktime")
	end,
	group = general,
	desc = "Update file when there are changes",
})

vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		vim.cmd("wincmd =")
	end,
	group = general,
	desc = "Equalize Splits",
})

-- Filetype colorschemes
-- local ft_colorschemes = vim.api.nvim_create_augroup("ft_colorschemes", { clear = true })
--
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
-- 	desc = "Temporarily change colorscheme for Markdown",
-- 	pattern = "*.md",
-- 	callback = function()
-- 		-- Save the current colorscheme *only if it hasn't been saved already*
-- 		if vim.g._previous_colorscheme == nil then
-- 			vim.g._previous_colorscheme = vim.g.colors_name
-- 		end
-- 		vim.cmd("colorscheme tokyonight")
-- 	end,
-- 	group = ft_colorschemes,
-- })
--
-- vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
-- 	desc = "Restore previous colorscheme after leaving Markdown",
-- 	pattern = "*.md",
-- 	callback = function()
-- 		if vim.g._previous_colorscheme then
-- 			vim.cmd("colorscheme " .. vim.g._previous_colorscheme)
-- 			vim.g._previous_colorscheme = nil
-- 		end
-- 	end,
-- 	group = ft_colorschemes,
-- })

-- jupyter notebook stuff
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.ipynb",
	callback = function()
		vim.bo.filetype = "markdown"
		vim.treesitter.language.register("markdown", "ipynb")
		vim.treesitter.start(vim.api.nvim_get_current_buf(), "markdown")
	end,
})

-- Toggle autosave for current buffer
function ToggleBufferAutoSave()
	local bufnr = vim.api.nvim_get_current_buf()
	local key = "autosave_enabled"

	-- Toggle the buffer-local variable
	local current = vim.b[key]
	if current then
		vim.b[key] = false
		vim.cmd("autocmd! AutoSaveBuffer" .. bufnr)
		vim.notify("AutoSave disabled for buffer " .. bufnr, vim.log.levels.INFO)
	else
		vim.b[key] = true
		local group = vim.api.nvim_create_augroup("AutoSaveBuffer" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
			group = group,
			buffer = bufnr,
			callback = function()
				if vim.b[key] and vim.bo.modifiable and vim.bo.modified then
					vim.cmd("silent write")
				end
			end,
		})
		vim.notify("AutoSave enabled for buffer " .. bufnr, vim.log.levels.INFO)
	end
end
vim.api.nvim_create_user_command("ToggleBufferAutoSave", ToggleBufferAutoSave, {})
