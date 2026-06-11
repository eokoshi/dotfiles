-- General Settings
local user_general = vim.api.nvim_create_augroup("UserGeneral", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function() vim.hl.on_yank() end,
	group = user_general,
	desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function() vim.opt.formatoptions:remove({ "c", "r", "o" }) end,
	group = user_general,
	desc = "Disable New Line Comment",
})

vim.api.nvim_create_autocmd("FocusGained", {
	callback = function() vim.cmd("checktime") end,
	group = user_general,
	desc = "Update file when there are changes",
})

vim.api.nvim_create_autocmd("VimResized", {
	callback = function() vim.cmd("wincmd =") end,
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

-- Syncing Config with Windows and chezmoi
local confsync = vim.api.nvim_create_augroup("ConfigSync", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = confsync,
	pattern = "*/.local/share/chezmoi/*",
	callback = function()
		local wsl = vim.fn.stdpath("config")
		local ch = vim.fn.expand("$HOME/.local/share/chezmoi/dot_config/nvim")
		-- assumes that a link to windows exists here (wsl)
		local win = vim.fn.expand("$HOME/windows/AppData/Local/nvim")

		if vim.fn.isdirectory(win) == 1 then
			-- add new spellings from windows before overwriting everything
			vim.system({ "rsync", "-rtu", win .. "/spell/", ch .. "/spell" }, { text = true })
		end

		local result = vim.system({ "chezmoi", "apply" }, { text = true }):wait(3000)

		if result.code == 0 then
			if vim.fn.isdirectory(win) == 1 then
				local rsync_result = vim
					.system({
						"rsync",
						"-a",
						"--delete",
						"--exclude",
						".git",
						"--exclude",
						"lazy-lock.json",
						wsl .. "/",
						win,
					}, {
						text = true,
					})
					:wait()
				if rsync_result.code == 0 then
					vim.notify(wsl .. " ⮕ " .. win, vim.log.levels.INFO, { title = "config sync" })
				else
					vim.notify("code=" .. rsync_result.code, vim.log.levels.ERROR, { title = "rsync error" })
				end
			end
		else
			vim.notify("Run chezmoi apply from command line.", vim.log.levels.ERROR, { title = "ch apply failed" })
		end
	end,
	desc = "Push edited config file to Windows via rsync",
})
