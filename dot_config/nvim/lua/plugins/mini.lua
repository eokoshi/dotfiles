local icons = require("stuff.icons")

local style
if vim.fn.environ()["TERM"] == "linux" then
	style = "ascii"
else
	style = "glyph"
end

return {
	-- {
	-- 	"nvim-mini/mini.operators",
	-- 	event = "BufEnter",
	-- 	opts = {},
	-- },
	{
		"nvim-mini/mini.align",
		event = "BufEnter",
		opts = {},
	},
	{
		"nvim-mini/mini.bracketed",
		event = "BufEnter",
		opts = {
			comment = { suffix = "" },
			file = { suffix = "e", options = {} },
			indent = { suffix = "j", options = {} },
			treesitter = { suffix = "" },
		},
	},
	{
		"nvim-mini/mini.icons",
		lazy = true,
		opts = {
			style = style,
			file = {
				[".chezmoiignore"] = { glyph = icons.basic.chezmoi, hl = "MiniIconsYellow" },
				[".chezmoiremove"] = { glyph = icons.basic.chezmoi, hl = "MiniIconsYellow" },
				[".chezmoiroot"] = { glyph = icons.basic.chezmoi, hl = "MiniIconsYellow" },
				[".chezmoiversion"] = { glyph = icons.basic.chezmoi, hl = "MiniIconsYellow" },
				["dot_bashrc"] = { glyph = icons.filetype.bash, hl = "MiniIconsCyan" },
				["dot_inputrc"] = { glyph = icons.filetype.bash, hl = "MiniIconsCyan" },
			},
			filetype = {
				dotenv = { glyph = icons.filetype.dotenv, hl = "MiniIconsYellow" },
				checkhealth = { glyph = icons.filetype.checkhealth, hl = "MiniIconsRed" },
				gotmpl = { glyph = icons.filetype.tmpl, hl = "MiniIconsGray" },
				sh = { glyph = icons.filetype.sh, hl = "MiniIconsGreen" },
				age = { glyph = icons.filetype.age, hl = "MiniIconsRed" },
			},
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
}
