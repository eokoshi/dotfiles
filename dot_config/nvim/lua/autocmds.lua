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
						vim.notify("Apply failed.\nRun chezmoi apply from command line.", vim.log.levels.ERROR)
					end
				end,
				on_stderr = function(_, data, _)
					if data ~= nil then
						vim.notify("Apply failed.\nRun chezmoi apply from command line.", vim.log.levels.ERROR)
					end
				end,
			}):start()
		end
	end,
	desc = "Apply changes in chezmoi files to local files (chezmoi source dir -> destination)",
})

-- Syncing Config with Windows
local winsync = vim.api.nvim_create_augroup("WindowsSync", { clear = true })

-- edit config in chezmoi dir, which syncs with local conf, which then updates the nvim conf repo
vim.api.nvim_create_autocmd("VimLeavePre", {
	group = chezmoi,
	pattern = "*/.local/share/chezmoi/*",
	callback = function(args)
		if string.match(args.match, ".*%.local/share/chezmoi/.*") ~= nil then
			local syscmd = function(cmd, silent)
				silent = silent or false
				vim.system(cmd, {
					cwd = vim.fn.stdpath("config"),
					stdout = function(_, data)
						if data ~= nil and silent ~= false then
							vim.notify(data, vim.log.levels.INFO)
						end
					end,
					stderr = function(_, data)
						if data ~= nil then
							vim.notify(data, vim.log.levels.ERROR)
						end
					end,
					text = true,
				}):wait()
			end
			syscmd({ "git", "add", "*" }, true)
			syscmd({ "git", "commit", "-m", "autocommit" }, true)
			local on_exit = function(_) end
			vim.system({ "git", "push" }, {
				cwd = vim.fn.stdpath("config"),
				stdout = function(_, data)
					if data ~= nil then
						vim.notify(data, vim.log.levels.INFO)
					end
				end,
				stderr = function(_, data)
					if data ~= nil then
						vim.notify(data, vim.log.levels.ERROR)
					end
				end,
				text = true,
				stdin = true,
				on_exit,
			})
		end
	end,
})

-- on windows machine, git pull config at every exit
if vim.fn.has("win32") == 1 then
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = winsync,
		pattern = "*",
		callback = function(args)
			local on_exit = function(_) end
			vim.system({ "git", "pull" }, {
				cwd = vim.fn.stdpath("config"),
				stdout = function(_, data)
					if data ~= nil then
						vim.notify(data, vim.log.levels.INFO)
					end
				end,
				stderr = function(_, data)
					if data ~= nil then
						vim.notify(data, vim.log.levels.ERROR)
					end
				end,
				text = true,
				on_exit,
			})
		end,
	})
end
