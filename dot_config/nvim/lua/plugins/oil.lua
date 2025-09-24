return {
	"stevearc/oil.nvim",
	dependencies = {
		{ "nvim-mini/mini.icons", opts = {} },
	},
	lazy = false,
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = false,
		columns = {
			{ "mtime", highlight = "Comment" },
			{ "size", highlight = "Ignore" },
			"icon",
		},
		delete_to_trash = true,
		watch_for_changes = true,
		keymaps = {
			["?"] = { "actions.show_help", mode = "n" },
			["<CR>"] = "actions.select",
			["<C-s>"] = { "actions.select", opts = { vertical = true } },
			["<C-b>"] = { "actions.select", opts = { horizontal = true } },
			["<C-p>"] = "actions.preview",
			["<C-c>"] = { "actions.close", mode = "n" },
			["<BS>"] = { "actions.parent", mode = "n" },
			["~"] = { "actions.open_cwd", mode = "n" },
			["@"] = { "actions.cd", mode = "n" },
			["gs"] = { "actions.change_sort", mode = "n" },
			["gx"] = "actions.open_external",
			["gy"] = "actions.yank_entry",
			["g."] = { "actions.toggle_hidden", mode = "n" },
			["g\\"] = { "actions.toggle_trash", mode = "n" },
			["q"] = { "actions.close", mode = "n" },
		},
		use_default_keymaps = false,
		view_options = {
			show_hidden = true,
			is_always_hidden = function(name, bufnr)
				local m = name:match("^__")
				return m ~= nil
			end,
			case_insensitive = true,
		},
		win_options = {
			cursorcolumn = false,
			colorcolumn = "",
			statuscolumn = " %l ",
			numberwidth = 2,
			relativenumber = false,
		},
		float = {
			max_height = 0.8,
			max_width = 0.8,
			border = "rounded",
			win_options = {
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Visual:FloatShadow",
			},
			title_pos = "center",
		},
	},
}
