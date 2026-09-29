local map = vim.keymap.set
local gh = require("functions").gh
vim.pack.add({
	{ src = gh("bngarren/checkmate.nvim") },
	{ src = gh("MeanderingProgrammer/render-markdown.nvim"), vim.version.range("*") },
	{ src = gh("jbyuki/nabla.nvim") },
})

--- nabla {{{
map("n", "<Leader>mm", function() require("nabla").popup({ border = "solid" }) end, { desc = "Show math popup" })
map("n", "<Leader>um", function() require("nabla").toggle_virt({ autogen = true, silent = true }) end, { desc = "Toggle math virtual text" })
--- }}}

--- obsidian {{{
obsidiangroup = vim.api.nvim_create_augroup("obsidian", { clear = true })

-- local function setup_obsidian() if _G.Obsidian then return end vim.pack.add({ { src = gh("obsidian-nvim/obsidian.nvim"), version = vim.version.range("*") } }) require("obsidian").setup({ legacy_commands = false, statusline = { enabled = false }, new_notes_location = "current_dir", link = { auto_update = true }, workspaces = { { name = "personal", path = "~/Documents/Obsidian", }, }, note_id_func = require("obsidian.builtin").title_id, templates = { folder = "Templates" }, ---@type obsidian.config.TemplateOpts picker = { name = "snacks.picker" }, daily_notes = { folder = "Daily Notes", template = "Templates/dailynote.md", }, ui = { enabled = false }, attachments = { folder = "Images" }, footer = { enabled = false }, checkbox = { enabled = false }, }) map("n", "<Leader>mt", "<CMD>Obsidian today<CR>", { desc = "today's note" }) map("n", "<Leader>my", "<CMD>Obsidian yesterday<CR>", { desc = "yesterday's note" }) map("n", "<Leader>md", "<CMD>Obsidian dailies -48 0<CR>", { desc = "find daily notes" }) map("n", "<Leader>mn", "<CMD>Obsidian new_from_template<CR>", { desc = "new from template" }) map("n", "<leader>mo", "<CMD>cd ~/Documents/Obsidian<CR>", { desc = "cd vault" }) vim.api.nvim_create_autocmd("User", { group = obsidiangroup, pattern = "ObsidianNoteEnter", callback = function() vim.keymap.set("n", "<CR>", function() local M = require("obsidian.api") if M.cursor_link() then return "<cmd>Obsidian follow_link<cr>" elseif M.cursor_tag() then return "<cmd>Obsidian tags<cr>" elseif M.cursor_heading() then return "za" else return "<cmd>Checkmate metadata toggle done<cr>" end end, { expr = true, buffer = true, desc = "smart action", }) end, }) end

local function pull_vault()
	local cwd = vim.fs.normalize("~/Documents/Obsidian")
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

local function setup_obsidian()
	pull_vault()
	local daily_note_dir = vim.fs.normalize("~/Documents/Obsidian/Daily Notes")
	map("n", "<Leader>mt", function() require("functions").open_daily_note(daily_note_dir) end, { desc = "today's daily note" })
	map("n", "<Leader>my", function() require("functions").open_previous_daily_note(daily_note_dir) end, { desc = "previous daily note" })
	map("n", "<leader>mo", "<CMD>cd ~/Documents/Obsidian<CR>", { desc = "cd vault" })
	vim.api.nvim_create_autocmd("DirChangedPre", {
		group = obsidiangroup,
		pattern = "global",
		callback = function()
			if string.match(vim.v.event.directory, "Obsidian") then pull_vault() end
		end,
	})
end

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	group = obsidiangroup,
	pattern = "**/[Oo]bsidian/**",
	once = true,
	callback = function() setup_obsidian() end,
})
vim.api.nvim_create_autocmd("VimEnter", {
	group = obsidiangroup,
	callback = function()
		if string.match(vim.fn.getcwd(), "[Oo]bsidian") then setup_obsidian() end
	end,
})

--- }}}

--- render-markdown {{{
require("render-markdown").setup({
	heading = { sign = false, position = "inline", icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " } },
	code = {
		sign = false,
		position = "right",
		width = "block",
		right_pad = 10,
		language_border = " ",
		language_left = "",
		language_right = "",
	},
	checkbox = { enabled = false },
	latex = { enabled = false },
	overrides = {
		buftype = {
			nofile = { code = { border = "hide", language = false, disable_background = true } },
		},
	},
})
--- }}}

--- checkmate {{{
require("checkmate").setup({ ---@as checkmate.Config
	files = { "*.md", "todo", "*.todo", "TODO" },
	todo_states = {
		checked = {
			marker = "󰸞",
		},
	},
	keys = false,
	metadata = {
		priority = {
			style = function(context)
				local value = context.value:lower()
				if value == "high" or value == "H" then
					return { fg = "#ff5555", bold = true }
				elseif value == "medium" or value == "M" then
					return { fg = "#ffb86c" }
				elseif value == "low" or value == "L" then
					return { fg = "#8be9fd" }
				elseif value == "wait" or value == "W" then
					return { fg = "#e100e1" }
				else
					return { fg = "#d7cb3a" }
				end
			end,
			get_value = function() return "medium" end,
			choices = function() return { "low", "medium", "high" } end,
			key = "<leader>mcp",
			sort_order = 10,
			jump_to_on_insert = "value",
			select_on_insert = true,
		},
		started = {
			aliases = { "init" },
			style = { fg = "#9fd6d5" },
			get_value = function() return tostring(os.date("%Y%m%d %H:%M")) end,
			key = "<leader>mcs",
			sort_order = 20,
		},
		done = {
			aliases = { "completed", "finished" },
			style = { fg = "#96de7a" },
			get_value = function() return tostring(os.date("%Y%m%d %H:%M")) end,
			on_add = function(todo_item) require("checkmate").set_todo_state(todo_item, "checked") end,
			on_remove = function(todo_item) require("checkmate").set_todo_state(todo_item, "unchecked") end,
			sort_order = 30,
		},
		due = {
			aliases = { "deadline", "by", "until", "duedate" },
			key = "<leader>mcd",
			get_value = function() return tostring(os.date("%Y%m%d", os.time() + (24 * 60 * 60 * 2))) end,
			jump_to_on_insert = "value",
			select_on_insert = true,
			style = function(context)
				local duedate = os.time({
					year = context.value:sub(1, 4),
					month = context.value:sub(5, 6),
					day = context.value:sub(7, 8),
				})
				local remaining = os.difftime(os.time(), duedate) / (24 * 60 * 60)
				if remaining > 0 then
					return { link = "DiagnosticUnderlineError" }
				elseif remaining > -1 then
					return { fg = "#ff5555", bold = true, reverse = true }
				elseif remaining > -7 then
					return { fg = "#ff6700", bold = true, reverse = true }
				elseif remaining > -14 then
					return { fg = "#ff8800", reverse = true }
				elseif remaining > -21 then
					return { fg = "#ffdb00", reverse = true }
				elseif remaining > -28 then
					return { fg = "#acff00", reverse = true }
				else
					return { fg = "#00b213" }
				end
			end,
			sort_order = 15,
		},
	},
})
--- }}}
