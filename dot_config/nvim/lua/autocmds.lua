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

		vim.system({ "chezmoi", "apply" }, { text = true, timeout = 1000 }, function(result)
			if result.code == 0 then
				if vim.fn.isdirectory(win) == 1 then
					vim.system({
						"rsync",
						"-a",
						"--delete",
						"--exclude",
						".git",
						"--exclude",
						"lazy-lock.json",
						wsl .. "/",
						win,
					}, { text = true }, function(rsync_result)
						if rsync_result.code == 0 then
							vim.notify(wsl .. " ⮕ " .. win, vim.log.levels.INFO, { title = "config sync" })
						else
							vim.notify("code=" .. rsync_result.code, vim.log.levels.ERROR, { title = "rsync error" })
						end
					end)
				end
			else
				vim.notify(result.stdout, vim.log.levels.ERROR, { title = "ch apply failed" })
			end
		end)
	end,
	desc = "Push edited config file to Windows via rsync",
})

-- auto nohlsearch
local autonohlsearch_group = vim.api.nvim_create_augroup("autonohlsearch", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = autonohlsearch_group,
	callback = function(opt)

		local function stop_hl()
			if vim.v.hlsearch == 0 then return end
			local keycode = vim.api.nvim_replace_termcodes("<Cmd>nohl<CR>", true, false, true)
			vim.api.nvim_feedkeys(keycode, "n", false)
		end

		local function start_hl()
			local res = vim.fn.getreg("/")
			if vim.v.hlsearch ~= 1 then return end
			if res ~= nil and res:find([[%#]], 1, true) then
				stop_hl()
				return
			end
			ok, status = pcall(vim.fn.search, [[\%#\zs]] .. res, "cnW")
			if ok and status == 0 then
				stop_hl()
				return
			end
		end

		local function hs_event(bufnr)
			if vim.b.autonohlsearch then return end
			vim.b.autonohlsearch = true
			local cm_id = vim.api.nvim_create_autocmd("CursorMoved", {
				buffer = bufnr,
				group = autonohlsearch_group,
				callback = function() start_hl() end,
				desc = "Auto hlsearch",
			})

			local ie_id = vim.api.nvim_create_autocmd("InsertEnter", {
				buffer = bufnr,
				group = autonohlsearch_group,
				callback = function() stop_hl() end,
				desc = "Auto remove hlsearch",
			})

			vim.api.nvim_create_autocmd("BufDelete", {
				buffer = bufnr,
				group = autonohlsearch_group,
				callback = function(data)
					vim.b.autonohlsearch = nil
					pcall(vim.api.nvim_del_autocmd, cm_id)
					pcall(vim.api.nvim_del_autocmd, ie_id)
					pcall(vim.api.nvim_del_autocmd, data.id)
				end,
			})
		end

		hs_event(opt.buf)
	end,
	desc = "hlsearch.nvim event",
})
