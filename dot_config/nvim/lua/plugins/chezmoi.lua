---@type LazySpec
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
				["bash.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
				["json.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
				["ps1.tmpl"] = { glyph = "󰨊", hl = "MiniIconsGrey" },
				["sh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
				["toml.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
				["yaml.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
				["zsh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
			},
		},
	},
}
