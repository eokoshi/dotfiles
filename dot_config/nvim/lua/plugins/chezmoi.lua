if true then
	return
end
return {
	{
		"xvzc/chezmoi.nvim",
		event = "VeryLazy",
		opts = {
			edit = {
				watch = true,
				force = false,
			},
			events = {
				on_open = {
					notification = {
						enable = false,
					},
				},
				on_watch = {
					notification = {
						enable = false,
					},
				},
				on_apply = {
					notification = {
						enable = true,
					},
				},
			},
		},
		init = function()
			-- run chezmoi edit on file enter
			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
				callback = function()
					vim.schedule(require("chezmoi.commands.__edit").watch)
				end,
			})

			vim.filetype.add({
				filename = {
					["dot_bashrc"] = "bash",
				},
				extension = {
					tmpl = "gotmpl",
				},
			})
		end,
	},
	-- Filetype icons
	{
		"echasnovski/mini.icons",
		opts = {
			file = {
				[".chezmoiignore"] = { glyph = "", hl = "MiniIconsGrey" },
				[".chezmoiremove"] = { glyph = "", hl = "MiniIconsGrey" },
				[".chezmoiroot"] = { glyph = "", hl = "MiniIconsGrey" },
				[".chezmoiversion"] = { glyph = "", hl = "MiniIconsGrey" },
				["dot_bashrc"] = { glyph = "", hl = "MiniIconsGrey" },
			},
		},
	},
}
