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
		local win = vim.fn.expand("$HOME/windows/AppData/Local/nvim")
		---@cast win string
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
						vim.schedule(function()
							if rsync_result.code == 0 then
								vim.api.nvim_echo({ { "Synced config to windows: " .. wsl .. " → " .. win, "Ignore" } }, false, { id = "configsyncwslwin" })
							else
								vim.api.nvim_echo({ { "code=" .. rsync_result.code } }, true, { err = true })
							end
						end)
					end)
				end
			else
				---@cast result.stdout string
				vim.schedule(function() vim.notify(result.stdout, vim.log.levels.ERROR, { title = "ch apply failed" }) end)
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
			---@cast res string
			if res:find([[%#]], 1, true) then
				stop_hl()
				return
			end
			local ok, status = pcall(vim.fn.search, [[\%#\zs]] .. res, "cnW")
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

-- editing init.lua
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("config", { clear = true }),
	pattern = "*/nvim/init.lua",
	callback = function()
		vim.opt_local.foldmethod = "marker"
		vim.opt_local.foldtext = "foldtext()"
	end,
})

-- Sessions
vim.api.nvim_create_user_command("SessionSave", function()
	local sessiondir = vim.fn.stdpath("state")
	---@cast sessiondir string
	sessiondir = vim.fs.joinpath(sessiondir, "sessions")
	if vim.fn.isdirectory(sessiondir) == 0 then vim.fn.mkdir(sessiondir, "p") end
	local curdir = vim.fn.getcwd()
	local filename = curdir:gsub("[\\:/%.]", "_") .. ".vim"
	local savepath = vim.fs.joinpath(sessiondir, filename)
	local cmd = string.format("mksession! %s", savepath)
	vim.cmd(cmd)
end, { desc = "Save mksession file for cwd" })
vim.api.nvim_create_user_command("SessionLoad", function()
	local sessiondir = vim.fn.stdpath("state")
	---@cast sessiondir string
	sessiondir = vim.fs.joinpath(sessiondir, "sessions")
	local curdir = vim.fn.getcwd()
	local filename = curdir:gsub("[\\:/%.]", "_") .. ".vim"
	local savepath = vim.fs.joinpath(sessiondir, filename)
	local cmd = string.format("source %s", savepath)
	vim.cmd(cmd)
end, { desc = "Load mksession file for cwd" })
local sessiongroup = vim.api.nvim_create_augroup("Sessions", { clear = true })
vim.api.nvim_create_autocmd({ "FocusLost", "CursorHold", "BufWritePost" }, {
	group = sessiongroup,
	command = "SessionSave",
})

-- help split
local help_group = vim.api.nvim_create_augroup("CustomHelpLayout", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = help_group,
	pattern = "*.txt,*.lua,*.md",
	callback = function(args)
		if vim.bo[args.buf].filetype ~= "help" then return end
		local cols = vim.o.columns
		local lines = vim.o.lines
		if (cols / lines > 3) and (cols > 180) then
			local current_win = vim.api.nvim_get_current_win()
			local target_win = nil
			-- 1. Search for an existing help window
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				if win ~= current_win and vim.bo[buf].filetype == "help" then
					target_win = win
					break
				end
			end
			-- 2. If an existing help window exists, move the help buffer into it
			if target_win and vim.api.nvim_win_is_valid(target_win) then
				vim.api.nvim_win_set_buf(target_win, args.buf)
				vim.api.nvim_set_current_win(target_win)
				if current_win ~= target_win then vim.api.nvim_win_close(current_win, false) end
			else
				vim.cmd.wincmd("L")
			end
		end
	end,
})

-- ui2
local ui2_group = vim.api.nvim_create_augroup("UI2WinOpts", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = ui2_group,
	pattern = "msg",
	callback = function()
		vim.wo.winhighlight = "NormalFloat:Float"
		vim.api.nvim_win_set_config(0, { border = "none" })
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = ui2_group,
	pattern = "pager",
	callback = function(ev)
		local detected_ft = vim.filetype.match({ buf = ev.buf }) or "pager"
		vim.bo[ev.buf].filetype = detected_ft
		vim.wo.winhighlight = "NormalFloat:Normal,FloatBorder:Blue"
		vim.api.nvim_win_set_config(0, { border = { "", "─", "", "", "", "", "", "" } })
	end,
})

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client ~= nil and client:supports_method("textDocument/foldingRange") then vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()" end
	end,
})

-- log
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.log",
	command = "setf log",
})
