-- General Settings
local general = vim.api.nvim_create_augroup("General", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
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

-- vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "BufWinLeave", "InsertLeave" }, {
-- 	-- nested = true, -- for format on save
-- 	callback = function()
-- 		if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
-- 			vim.cmd("silent! w")
-- 		end
-- 	end,
-- 	group = general,
-- 	desc = "Auto Save",
-- })

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

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "markdown", "text", "log" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
	group = general,
	desc = "Enable Wrap in these filetypes",
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
