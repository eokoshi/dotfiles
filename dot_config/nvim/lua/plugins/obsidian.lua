if vim.fn.has("win32") == 1 then
	return {
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			daily_notes = {
				folder = "Daily Notes",
				template = "Templates/dailynote.md",
			},
			new_notes_subdir = "current_dir",
			completion = {
				blink = true,
			},
			picker = {
				name = "snacks.pick",
			},
			ui = {
				enable = false,
			},
			attachments = {
				img_folder = "Images",
			},
			footer = {
				enabled = false,
			},
			statusline = {
				enabled = false,
			},
			workspaces = {
				{
					name = "personal",
					path = "~/Documents/Obsidian",
				},
			},
			checkbox = {
				enabled = false,
			},
			templates = {
				folder = "Templates",
			},
			-- Customize the frontmatter data.
			---@return table
			frontmatter = {
				func = function(note)
					-- Add the title of the note as an alias.
					if note.title then
						note:add_alias(note.title)
					end
					note:add_field("date", os.date("%Y-%m-%d"))

					local out = { aliases = note.aliases, date = note.date, tags = note.tags }

					-- `note.metadata` contains any manually added fields in the frontmatter.
					-- So here we just make sure those fields are kept in the frontmatter.
					if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
						for k, v in pairs(note.metadata) do
							out[k] = v
						end
					end

					return out
				end,
			},
			---@param url string
			follow_url_func = function(url)
				vim.ui.open(url) -- need Neovim 0.10.0+
			end,
			legacy_commands = false,
		},
		init = function()
			local map = require("stuff.functions").map
			map("n", "<Leader>mt", "<CMD>Obsidian today<CR>", { desc = "today's note" })
			map("n", "<Leader>my", "<CMD>Obsidian yesterday<CR>", { desc = "yesterday's note" })
			map("n", "<Leader>mf", "<CMD>Obsidian dailies -48 0<CR>", { desc = "find daily notes" })
			map("n", "<Leader>mn", "<CMD>Obsidian new_from_template<CR>", { desc = "new from template" })
			map("n", "<leader>mo", "<CMD>cd ~/Documents/Obsidian<CR>", { desc = "cd vault" })

			vim.api.nvim_create_autocmd("User", {
				pattern = "ObsidianNoteEnter",
				callback = function()
					vim.keymap.set("n", "<CR>", function()
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
					---@diagnostic disable-next-line: undefined-field
					if string.match(vim.v.event.directory, "\\Obsidian") then
						vim.system({ "git", "pull" }, {
							cwd = vim.fn.expand("$HOME/Documents/Obsidian"),
							text = true,
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
						}, function(_) end)
					end
				end,
			})
		end,
	}
else
	return {}
end
