vim.diagnostic.enable(false)
vim.o.swapfile = false

vim.opt.shelltemp = false
vim.opt.shell = "pwsh"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
	.. "[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();"
	.. "$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
	.. "$PSStyle.OutputRendering = 'PlainText';"
vim.opt.shellpipe = "> %s 2>&1"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
vim.env.__SuppressAnsiEscapeSequences = 1

require("neovide")

--- Obsidian
vim.api.nvim_create_autocmd("DirChangedPre", {
	pattern = "global",
	callback = function()
		if string.match(vim.v.event.directory, "\\Obsidian") then
			local cwd = vim.fn.expand("~/Documents/Obsidian")
			---@cast cwd string
			vim.system(
				{ "git", "pull" },
				{ cwd = cwd, text = true },
				vim.schedule_wrap(function(obj)
					if obj.stdout ~= nil then
						vim.api.nvim_echo({ { obj.stdout } }, true, {})
					elseif obj.stderr ~= nil then
						vim.api.nvim_echo({ { obj.stdout } }, true, { err = true })
					end
				end)
			)
		end
	end,
})

-- what do to when opened without a specific file
if vim.fn.argc() == 0 then
	vim.cmd({ cmd = "cd", args = { vim.fn.expand("~/Documents/Obsidian") } })
else
	vim.notify(vim.fn.getcwd())
end
