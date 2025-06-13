-- stylua: ignore
-- if true then return {} end

return {
	'stevearc/oil.nvim',
	dependencies = {
		{ "echasnovski/mini.icons", opts = {} }
	},
	lazy = false,
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		columns = {
			"icon",
			"size",
			"mtime",
			"atime",
		},
		delete_to_trash = true,
		watch_for_changes = true,
		keymaps = {
			["g?"] = { "actions.show_help", mode = "n" },
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
		},
		use_default_keymaps = false,
		view_options = {
			show_hidden = true,
			case_insensitive = true,
		}
	},
}
