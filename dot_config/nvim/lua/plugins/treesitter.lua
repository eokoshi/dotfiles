local parsers = {}
if vim.fn.has("win32") == 1 then
	parsers = {
		"c",
		"css",
		"diff",
		"dockerfile",
		"git_config",
		"gitignore",
		"html",
		"htmldjango",
		"javascript",
		"jsdoc",
		"json",
		"latex",
		"markdown",
		"markdown_inline",
		"printf",
		"python",
		"r",
		"regex",
		"sql",
		"ssh_config",
		"toml",
		"tsv",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
		"xml",
		"yaml",
	}
else -- linux
	parsers = {
		"bash",
		"c",
		"css",
		"diff",
		"dockerfile",
		"git_config",
		"gitignore",
		"gotmpl",
		"html",
		"htmldjango",
		"javascript",
		"jsdoc",
		"json",
		"latex",
		"lua",
		"luadoc",
		"luap",
		"markdown",
		"markdown_inline",
		"printf",
		"python",
		"query",
		"r",
		"readline",
		"regex",
		"scheme",
		"sql",
		"ssh_config",
		"toml",
		"tmux",
		"tsv",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
		"xml",
		"yaml",
	}
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		dependencies = {
			"mason-org/mason.nvim",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context",
		},
	},
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			ensure_installed = parsers,
			ignore_install = { "csv" },
			auto_install = vim.fn.executable("tree-sitter") == 1, -- only enable auto install if `tree-sitter` cli is installed
			fold = { enable = true },
			highlight = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "gnn",
					scope_incremental = "gns",
					node_decremental = "gnm",
				},
			},
			indent = { enable = true },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		opts = {
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
		},
		init = function()
			local map = require("stuff.functions").map
			-- stylua: ignore start

			-- Select
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

			-- Swap
			local swap = require("nvim-treesitter-textobjects.swap")
			map({ "n" }, ">k", function() swap.swap_next("@block.outer", "textobjects") end, { desc = "swap next block" })
			map({ "n" }, ">c", function() swap.swap_next("@class.outer", "textobjects") end, { desc = "swap next class" })
			map({ "n" }, ">f", function() swap.swap_next("@function.outer", "textobjects") end, { desc = "swap next function" })
			map({ "n" }, ">a", function() swap.swap_next("@parameter.inner", "textobjects") end, { desc = "swap next argument" })
			map({ "n" }, "<k", function() swap.swap_previous("@block.outer", "textobjects") end, { desc = "swap prev block" })
			map({ "n" }, "<c", function() swap.swap_previous("@class.outer", "textobjects") end, { desc = "swap prev class" })
			map({ "n" }, "<f", function() swap.swap_previous("@function.outer", "textobjects") end, { desc = "swap prev function" })
			map({ "n" }, "<a", function() swap.swap_previous("@parameter.inner", "textobjects") end, { desc = "swap prev argument" })

			-- Move
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

			-- stylua: ignore end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = true,
		opts = {
			multiwindow = true,
			max_lines = 3,
			multiline_threshold = 1,
			mode = "topline",
		},
	},
}
