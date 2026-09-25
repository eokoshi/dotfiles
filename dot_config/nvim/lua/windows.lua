local map = vim.keymap.set
local init_augroup_win = vim.api.nvim_create_augroup("init_win", { clear = true })
-- vim.diagnostic.enable(false)
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

-- Mappings {{{
map("n", "<Leader>c", "<CMD>bd!<CR>", { desc = "bufdelete" })
-- }}}

-- Packages {{{
vim.api.nvim_create_autocmd("PackChanged", {
	group = init_augroup_win,
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then vim.cmd("packadd nvim-treesitter") end
			vim.cmd("TSUpdate")
		elseif name == "mason" and kind == "update" then
			if not ev.data.active then vim.cmd("packadd mason.nvim") end
			vim.cmd("MasonUpdate")
		elseif name == "fff" and (kind == "update" or kind == "install") then
			if not ev.data.active then vim.cmd("packadd fff") end
			require("fff.download").download_or_build_binary()
		end
	end,
})
local gh = require("functions").gh
vim.pack.add({
	{ src = gh("neovim/nvim-lspconfig"), version = vim.version.range("*") },
	{ src = gh("nvim-treesitter/nvim-treesitter") },
	{ src = gh("nvim-treesitter/nvim-treesitter-textobjects") },
	{ src = gh("sainnhe/sonokai") },
	{ src = gh("nvim-mini/mini.nvim") },
	{ src = gh("kylechui/nvim-surround") },
	{ src = gh("stevearc/conform.nvim") },
})

--- nvim-surround {{{
require("nvim-surround").setup({})
--- }}}

--- mini.nvim {{{
require("mini.splitjoin").setup({})
require("mini.align").setup({})
local miniclue = require("mini.clue")
miniclue.setup({
	triggers = {
		{ mode = { "n", "x" }, keys = "<Leader>" },
		{ mode = { "n", "x" }, keys = "<Localleader>" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
		{ mode = "i", keys = "<C-x>" },
		{ mode = { "n", "x" }, keys = "g" },
		{ mode = { "n", "x" }, keys = "'" },
		{ mode = { "n", "x" }, keys = "`" },
		{ mode = { "n", "x" }, keys = '"' },
		{ mode = { "i", "c" }, keys = "<C-r>" },
		{ mode = "n", keys = "<C-w>" },
		{ mode = { "n", "x" }, keys = "z" },
		{ mode = { "n", "x" }, keys = ">" },
		{ mode = { "n", "x" }, keys = "<" },
	},
	clues = {
		{ keys = "<Leader>e", mode = { "n" }, desc = "Explorer" },
		{ keys = "<Leader>f", mode = { "n", "x" }, desc = "Find" },
		{ keys = "<Leader>g", mode = { "n", "x" }, desc = "Git" },
		{ keys = "<Leader>l", mode = { "n", "x" }, desc = "Language Tools" },
		{ keys = "<Leader>b", mode = "n", desc = "Buffers" },
		{ keys = "<Leader>u", mode = "n", desc = "UI" },
		{ keys = "<Leader>d", mode = "n", desc = "Debugger" },
		{ keys = "<Leader>n", mode = "n", desc = "Network" },
		{ keys = "<Leader>p", mode = "n", desc = "Packages" },
		{ keys = ">>", mode = "n", desc = "indent line" },
		{ keys = "<<", mode = "n", desc = "unindent line" },
		miniclue.gen_clues.square_brackets(),
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},
	window = {
		delay = 500,
		config = {
			width = "auto",
		},
	},
})

local MiniPick = require("mini.pick")
local ui_select_orig = vim.ui.select
MiniPick.setup({})
vim.ui.select = ui_select_orig

local width = 80
local height = 10
local picker_winconfig = {
	relative = "editor",
	row = vim.o.lines * 0.5 + (height / 2),
	col = vim.o.columns * 0.5 - (width / 2),
	width = width,
	height = height,
}

map("n", "vv", function()
	MiniPick.builtin.buffers({ include_current = false }, {
		mappings = {
			wipeout = {
				char = "<C-d>",
				func = function()
					local matches = MiniPick.get_picker_matches()
					if matches ~= nil then vim.api.nvim_buf_delete(matches.current.bufnr, {}) end
				end,
			},
		},
		options = { content_from_bottom = false, use_cache = true },
		window = { config = picker_winconfig },
	})
end, { desc = "pick buffer" })

map(
	"n",
	"ff",
	function() MiniPick.builtin.files({}, { options = { content_from_bottom = false, use_cache = true }, window = { config = picker_winconfig } }) end,
	{ desc = "live file" }
)

map(
	"n",
	"<leader>fw",
	function() MiniPick.builtin.grep_live({}, { options = { content_from_bottom = false, use_cache = true }, window = { config = picker_winconfig } }) end,
	{ desc = "live grep" }
)

map(
	"n",
	"<leader>fh",
	function() MiniPick.builtin.help({}, { options = { content_from_bottom = false, use_cache = true }, window = { config = picker_winconfig } }) end,
	{ desc = "find help" }
)

local MiniExtra = require("mini.extra")
map(
	"n",
	"<leader>fH",
	function() MiniExtra.pickers.hl_groups({}, { options = { content_from_bottom = false, use_cache = true }, window = { config = picker_winconfig } }) end,
	{ desc = "find highlight" }
)

map(
	"n",
	"<leader>fk",
	function() MiniExtra.pickers.keymaps({}, { options = { content_from_bottom = false, use_cache = true }, window = { config = picker_winconfig } }) end,
	{ desc = "find keymap" }
)

local MiniTabline = require("mini.tabline")
MiniTabline.setup({
	tabpage_section = "right",
	format = function(buf_id, label)
		local suffix = vim.bo[buf_id].modified and "○ " or ""
		return MiniTabline.default_format(buf_id, label) .. suffix
	end,
})
local function tabline_colors()
	vim.api.nvim_set_hl(0, "TabLineFill", {
		bg = nil,
	})
	vim.api.nvim_set_hl(0, "MiniTablineCurrent", {
		fg = vim.api.nvim_get_hl(0, { name = "Number" }).fg,
		bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg,
		dim = true,
		italic = true,
	})
	vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", {
		fg = vim.api.nvim_get_hl(0, { name = "Number" }).fg,
		bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg,
		dim = true,
	})
	vim.api.nvim_set_hl(0, "MiniTablineVisible", {
		fg = vim.api.nvim_get_hl(0, { name = "Ignore" }).fg,
		bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg,
		dim = true,
		italic = true,
	})
	vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", {
		fg = vim.api.nvim_get_hl(0, { name = "Number" }).fg,
		bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg,
		dim = true,
	})
	vim.api.nvim_set_hl(0, "MiniTablineHidden", {
		fg = vim.api.nvim_get_hl(0, { name = "Number" }).fg,
		dim = true,
	})
	vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", {
		fg = vim.api.nvim_get_hl(0, { name = "Number" }).fg,
		dim = true,
	})
end
tabline_colors()
vim.api.nvim_create_autocmd("ColorScheme", {
	group = init_augroup_win,
	callback = tabline_colors,
})

local style
if vim.env.TERM == "linux" then
	style = "ascii"
else
	style = "glyph"
end
local MiniIcons = require("mini.icons")
local icons = require("stuff.icons")
MiniIcons.setup({
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
})
package.preload["nvim-web-devicons"] = function()
	MiniIcons.mock_nvim_web_devicons()
	return package.loaded["nvim-web-devicons"]
end

local MiniFiles = require("mini.files")
MiniFiles.setup({
	options = {
		permanent_delete = false,
	},
	windows = {
		preview = false,
	},
	mappings = {
		close = "<esc>",
		go_in = "<right>",
		go_in_plus = "L",
		go_out = "H",
		go_out_plus = "<left>",
		synchronize = "<leader>w",
		mark_goto = ";",
		show_help = "?",
		reset = "<home>",
	},
})
local mfutils = require("plugins.minifiles_utils")
map("n", "<leader>e", function()
	mfutils.minifiles_toggle(vim.api.nvim_buf_get_name(0), false)
	MiniFiles.reveal_cwd()
end, { desc = "MiniFiles" })
vim.api.nvim_create_autocmd("User", {
	group = init_augroup_win,
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local b = args.data.buf_id
		map("n", "<leader>.", function() MiniFiles.open(nil) end, { buffer = b, desc = "go to cwd" })
		map("n", "J", "<DOWN>", { buffer = b })
		map("n", "K", "<UP>", { buffer = b })
		map("n", "<CR>", function() MiniFiles.go_in({ close_on_file = true }) end, { buffer = b })
		map("n", "q", function() MiniFiles.close() end, { buffer = b })
		map("n", "g.", mfutils.set_cwd, { buffer = b, desc = "Set cwd" })
		map("n", "gy", mfutils.yank_path, { buffer = b, desc = "Yank path" })
		map("n", "<C-space>", mfutils.toggle_preview, { buffer = b, desc = "Toggle preview" })
	end,
})
vim.api.nvim_set_hl(0, "MiniFilesTitle", { link = "FloatTitle" })
--- }}}

--- TreeSitter {{{

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = {
			["@block.outer"] = "V",
			["@block.inner"] = "V",
			["@class.outer"] = "V",
			["@class.inner"] = "V",
			["@conditional.outer"] = "V",
			["@conditional.inner"] = "v",
			["@function.outer"] = "V",
			["@function.inner"] = "V",
			["@call.outer"] = "V",
			["@call.inner"] = "V",
			["@loop.outer"] = "V",
			["@loop.inner"] = "V",
			["@parameter.outer"] = "v",
			["@parameter.inner"] = "v",
			["@import.outer"] = "V",
		},
	},
	move = {
		set_jumps = true,
	},
})
local select = require("nvim-treesitter-textobjects.select").select_textobject
map({ "x", "o" }, "ak", function() select("@block.outer", "textobjects") end, { desc = "block" })
map({ "x", "o" }, "ik", function() select("@block.inner", "textobjects") end, { desc = "block" })
map({ "x", "o" }, "ac", function() select("@class.outer", "textobjects") end, { desc = "class" })
map({ "x", "o" }, "ic", function() select("@class.inner", "textobjects") end, { desc = "class" })
map({ "x", "o" }, "a?", function() select("@conditional.outer", "textobjects") end, { desc = "conditional" })
map({ "x", "o" }, "i?", function() select("@conditional.inner", "textobjects") end, { desc = "conditional" })
map({ "x", "o" }, "af", function() select("@function.outer", "textobjects") end, { desc = "function" })
map({ "x", "o" }, "if", function() select("@function.inner", "textobjects") end, { desc = "function" })
map({ "x", "o" }, "ax", function() select("@call.outer", "textobjects") end, { desc = "call" })
map({ "x", "o" }, "ix", function() select("@call.inner", "textobjects") end, { desc = "call" })
map({ "x", "o" }, "al", function() select("@loop.outer", "textobjects") end, { desc = "loop" })
map({ "x", "o" }, "il", function() select("@loop.inner", "textobjects") end, { desc = "loop" })
map({ "x", "o" }, "aa", function() select("@parameter.outer", "textobjects") end, { desc = "argument" })
map({ "x", "o" }, "ia", function() select("@parameter.inner", "textobjects") end, { desc = "argument" })
map({ "x", "o" }, "i=", function() select("@assignment.rhs", "textobjects") end, { desc = "assignment rhs" })
map({ "x", "o" }, "a=", function() select("@assignment.outer", "textobjects") end, { desc = "assignment" })
local swap = require("nvim-treesitter-textobjects.swap")
map({ "n" }, ">k", function() swap.swap_next("@block.outer", "textobjects") end, { desc = "swap next block" })
map({ "n" }, ">c", function() swap.swap_next("@class.outer", "textobjects") end, { desc = "swap next class" })
map({ "n" }, ">f", function() swap.swap_next("@function.outer", "textobjects") end, { desc = "swap next function" })
map({ "n" }, ">a", function() swap.swap_next("@parameter.inner", "textobjects") end, { desc = "swap next argument" })
map({ "n" }, "<k", function() swap.swap_previous("@block.outer", "textobjects") end, { desc = "swap prev block" })
map({ "n" }, "<c", function() swap.swap_previous("@class.outer", "textobjects") end, { desc = "swap prev class" })
map({ "n" }, "<f", function() swap.swap_previous("@function.outer", "textobjects") end, { desc = "swap prev function" })
map({ "n" }, "<a", function() swap.swap_previous("@parameter.inner", "textobjects") end, { desc = "swap prev argument" })
local move = require("nvim-treesitter-textobjects.move")
map({ "x", "o", "n" }, "]k", function() move.goto_next_start("@block.outer", "textobjects") end, { desc = "block" })
map({ "x", "o", "n" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "function" })
map({ "x", "o", "n" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end, { desc = "argument" })
map({ "x", "o", "n" }, "]i", function() move.goto_next_start("@import.outer", "textobjects") end, { desc = "import" })
map({ "x", "o", "n" }, "[k", function() move.goto_previous_start("@block.outer", "textobjects") end, { desc = "block" })
map({ "x", "o", "n" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "function" })
map({ "x", "o", "n" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end, { desc = "argument" })
map({ "x", "o", "n" }, "[i", function() move.goto_previous_start("@import.outer", "textobjects") end, { desc = "import" })
local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move, { desc = "repeat last move" })
map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite, { desc = "undo last move" })
map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
--- }}}

--- conform {{{
require("conform").setup({ ---@as conform.setupOpts
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
		r = { "air" },
		htmldjango = { "djlint" },
		yaml = { "prettier" },
		json = { "fixjson", "jq", "prettier", stop_after_first = true },
		css = { "prettier" },
		javascript = { "prettier" },
		gotmpl = { "shfmt" },
		rust = { "rustfmt" },
		xml = { "xmlformat" },
		dts = { "dts_format" },
	},
	default_format_opts = {
		timeout_ms = 3000,
		async = false,
		quiet = false,
		lsp_format = "fallback",
	},
	format_on_save = function(bufnr)
		if vim.b[bufnr].autoformat or vim.b[bufnr].autoformat == nil then return { timeout_ms = 500, lsp_format = "fallback" } end
	end,
	formatters = {
		ruff_format = { append_args = { "--extension", "ipynb:python" } },
		stylua = {
			append_args = function()
				local paths = {
					vim.fn.getcwd() .. "/.stylua.toml",
					vim.fn.getcwd() .. "/stylua.toml",
					vim.fn.stdpath("config") .. "/.stylua.toml",
					vim.fn.stdpath("config") .. "/stylua.toml",
				}
				for _, config in ipairs(paths) do
					if vim.fn.filereadable(config) == 1 then return { "--config-path", config } end
				end
				return {}
			end,
		},
		dts_format = {
			command = "dts-format",
			args = { "--fix", "--use-tabs", "$FILENAME" },
			stdin = false,
			cwd = require("conform.util").root_file("zmk"),
		},
	},
})
map("n", "<Leader>lc", "<CMD>ConformInfo<CR>", { desc = "Formatter info" })
map("n", "<Leader>bf", function() require("conform").format({ async = true }) end, { desc = "format buffer" })
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.api.nvim_create_user_command("FormatDisable", function() vim.b.autoformat = false end, { desc = "Disable autoformat-on-save" })
vim.api.nvim_create_user_command("FormatEnable", function() vim.b.autoformat = true end, { desc = "Enable autoformat-on-save" })
--- }}}

--- }}}

--- ColorSchemes {{{

vim.g.sonokai_enable_italic = 1
vim.g.sonokai_transparent_background = 1
vim.g.sonokai_dim_inactive_windows = 1

vim.cmd("colorscheme sonokai")

--- }}}

-- vim: fdm=marker
