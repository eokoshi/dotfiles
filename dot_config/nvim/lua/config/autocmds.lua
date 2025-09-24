-- General Settings
local user_general = vim.api.nvim_create_augroup("UserGeneral", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
	group = user_general,
	desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	group = user_general,
	desc = "Disable New Line Comment",
})

vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		vim.cmd("checktime")
	end,
	group = user_general,
	desc = "Update file when there are changes",
})

vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		vim.cmd("wincmd =")
	end,
	group = user_general,
	desc = "Equalize Splits",
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = user_general,
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		if vim.bo[bufnr].buftype == "nofile" then
			vim.opt.colorcolumn = ""
		else
			vim.opt.colorcolumn = "+1"
		end
	end,
	desc = "Remove colorcolumn in nofile buffers",
})

-- Chezmoi
local chezmoi = vim.api.nvim_create_augroup("Chezmoi", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = chezmoi,
	pattern = "*/.local/share/chezmoi/*",
	callback = function(args)
		if string.match(args.match, ".*%.local/share/chezmoi/.*") ~= nil then
			local Job = require("plenary.job")
			---@diagnostic disable-next-line: missing-fields
			Job:new({
				command = "chezmoi",
				args = { "apply" },
				cwd = "~",
				on_stdout = function(_, data, _)
					if data ~= nil then
						vim.notify("Apply failed.\n\nRun chezmoi apply from command line.", vim.log.levels.ERROR)
					end
				end,
				on_stderr = function(_, data, _)
					if data ~= nil then
						vim.notify("Apply failed.\n\nRun chezmoi apply from command line.", vim.log.levels.ERROR)
					end
				end,
			}):start()
		end
	end,
	desc = "Apply changes in chezmoi files to local files (chezmoi source dir -> destination)",
})
