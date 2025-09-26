return {
	"obsidian-nvim/obsidian.nvim",
	enabled = function()
		if vim.fn.has("win32") then
			return true
		else
			return false
		end
	end,
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
		completion = {
			blink = true,
			nvim_cmp = false,
		},
		new_notes_subdir = "current_dir",
		picker = {
			name = "snacks.pick",
		},
		ui = {
			enable = false,
		},
		attachments = {
			img_folder = "Images",
		},
		workspaces = {
			{
				name = "personal",
				path = "~/obsidian",
			},
			--   {
			--     name = "work",
			--     path = "~/vaults/work",
			--   },
		},
		templates = {
			folder = "Templates",
		},
		-- Customize the frontmatter data.
		---@return table
		note_frontmatter_func = function(note)
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

		-- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
		-- URL it will be ignored but you can customize this behavior here.
		---@param url string
		follow_url_func = function(url)
			-- Open the URL in the default web browser.
			-- vim.fn.jobstart({"open", url})  -- Mac OS
			vim.fn.jobstart({ "wsl-open", url }) -- linux
			-- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
			-- vim.ui.open(url) -- need Neovim 0.10.0+
		end,
		legacy_commands = false,
	},
}
