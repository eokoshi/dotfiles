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

local gh = function(x) return "https://github.com/" .. x end
vim.pack.add({
	{ src = gh("obsidian-nvim/obsidian.nvim"), version = vim.version.range("*") },
})
local map = require("stuff.functions").map
require("obsidian").setup({
	legacy_commands = false,
	statusline = { enabled = false },
	new_notes_location = "current_dir",
	link = { auto_update = true },
	workspaces = {
		{
			name = "personal",
			path = "~/Documents/Obsidian",
		},
	},
	note_id_func = require("obsidian.builtin").title_id,
	templates = { folder = "Templates" },
	picker = { name = "snacks.picker" },
	daily_notes = {
		folder = "Daily Notes",
		template = "Templates/dailynote.md",
	},
	ui = { enabled = false },
	attachments = { folder = "Images" },
	footer = { enabled = false },
	checkbox = { enabled = false },
})
map("n", "<Leader>mt", "<CMD>Obsidian today<CR>", { desc = "today's note" })
map("n", "<Leader>my", "<CMD>Obsidian yesterday<CR>", { desc = "yesterday's note" })
map("n", "<Leader>md", "<CMD>Obsidian dailies -48 0<CR>", { desc = "find daily notes" })
map("n", "<Leader>mn", "<CMD>Obsidian new_from_template<CR>", { desc = "new from template" })
map("n", "<leader>mo", "<CMD>cd ~/Documents/Obsidian<CR>", { desc = "cd vault" })
vim.api.nvim_create_autocmd("User", {
	pattern = "ObsidianNoteEnter",
	callback = function()
		vim.keymap.set("n", "<CR>", function()
			---@diagnostic disable-next-line: unresolved-require
			local M = require("obsidian.api")
			if M.cursor_link() then
				return "<cmd>Obsidian follow_link<cr>"
			elseif M.cursor_tag() then
				return "<cmd>Obsidian tags<cr>"
			elseif M.cursor_heading() then
				return "za"
			else
				return "<cmd>Checkmate metadata toggle done<cr>"
			end
		end, {
			expr = true,
			buffer = true,
			desc = "smart action",
		})
	end,
})
vim.api.nvim_create_autocmd("DirChangedPre", {
	pattern = "global",
	callback = function()
		if string.match(vim.v.event.directory, "\\Obsidian") then
			local cwd = vim.fn.expand("$HOME/Documents/Obsidian")
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
	vim.cmd({ cmd = "cd", args = { vim.fs.joinpath(vim.fn.expand("~"), "Documents/Obsidian") } })
else
	vim.notify(vim.fn.getcwd())
end
