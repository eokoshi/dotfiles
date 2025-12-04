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
	callback = function()
		vim.system({ "chezmoi", "apply" }, {
			stdout = function(_, data)
				if data ~= nil then
					vim.notify("Apply failed.\nRun chezmoi apply from command line.", vim.log.levels.ERROR)
				end
			end,
			stderr = function(_, data)
				if data ~= nil then
					vim.notify("Apply failed.\nRun chezmoi apply from command line.", vim.log.levels.ERROR)
				end
			end,
			text = true,
		}, function(_) end)
	end,
	desc = "Apply changes in chezmoi files to local files (chezmoi source dir -> destination)",
})

-- Syncing Config with Windows
local winsync = vim.api.nvim_create_augroup("WindowsSync", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
	group = winsync,
	pattern = "*/.local/share/chezmoi/*",
	callback = function()
		local src = vim.fn.stdpath("config") .. "/"
		local dst = vim.fn.expand("$HOME/windows/AppData/Local/nvim")
		local cmd = { "rsync", "-au", "--delete", "--exclude", ".git", "--exclude", "lazy-lock.json", src, dst }

		vim.system(cmd, {
			text = true,
		}, function(completed)
			local code = completed.code
			if code == 0 then
				vim.notify("Config synced to Windows", vim.log.levels.INFO)
			else
				vim.notify("rsync failed (code " .. code .. ")", vim.log.levels.ERROR)
			end
		end)

		-- add new spellings from windows
		vim.system({ "rsync", "-rt", dst .. "/spell/", src .. "spell" }, { text = true }, function(_) end)
	end,
	desc = "Push edited config file to Windows via rsync",
})
