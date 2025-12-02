return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		main = "nvim-treesitter.configs",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
			{
				"nvim-treesitter/nvim-treesitter-context",
				lazy = true,
				opts = {
					multiwindow = true,
					multiline_threshold = 2,
				},
			},
			"mason-org/mason.nvim",
		},
		lazy = false,
		cmd = {
			"TSBufDisable",
			"TSBufEnable",
			"TSBufToggle",
			"TSDisable",
			"TSEnable",
			"TSToggle",
			"TSInstall",
			"TSInstallInfo",
			"TSInstallSync",
			"TSModuleInfo",
			"TSUninstall",
			"TSUpdate",
			"TSUpdateSync",
		},
		build = ":TSUpdate",
		-- load treesitter immediately when opening a file from the cmdline
		init = function(plugin)
			-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
			-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
			-- no longer trigger the **nvim-treesitter** module to be loaded in time.
			-- Luckily, the only things that those plugins need are the custom queries, which we make available
			-- during startup.
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"dockerfile",
				"git_config",
				"gotmpl",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
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
				"regex",
				"sql",
				"ssh_config",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			},
			auto_install = vim.fn.executable("tree-sitter") == 1, -- only enable auto install if `tree-sitter` cli is installed
			highlight = { enable = true },
			incremental_selection = { enable = true },
			indent = { enable = true },
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["ak"] = { query = "@block.outer", desc = "around block" },
						["ik"] = { query = "@block.inner", desc = "inside block" },
						["ac"] = { query = "@class.outer", desc = "around class" },
						["ic"] = { query = "@class.inner", desc = "inside class" },
						["a?"] = { query = "@conditional.outer", desc = "around conditional" },
						["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
						["af"] = { query = "@function.outer", desc = "around function " },
						["if"] = { query = "@function.inner", desc = "inside function " },
						["al"] = { query = "@loop.outer", desc = "around loop" },
						["il"] = { query = "@loop.inner", desc = "inside loop" },
						["aa"] = { query = "@parameter.outer", desc = "around argument" },
						["ia"] = { query = "@parameter.inner", desc = "inside argument" },
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]k"] = { query = "@block.outer", desc = "Next block start" },
						["]f"] = { query = "@function.outer", desc = "Next function start" },
						["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
						["]i"] = { query = "@import.outer", desc = "Next import start" },
					},
					goto_next_end = {
						["]K"] = { query = "@block.outer", desc = "Next block end" },
						["]F"] = { query = "@function.outer", desc = "Next function end" },
						["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
					},
					goto_previous_start = {
						["[k"] = { query = "@block.outer", desc = "Previous block start" },
						["[f"] = { query = "@function.outer", desc = "Previous function start" },
						["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
						["[i"] = { query = "@import.outer", desc = "Previous import start" },
					},
					goto_previous_end = {
						["[K"] = { query = "@block.outer", desc = "Previous block end" },
						["[F"] = { query = "@function.outer", desc = "Previous function end" },
						["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
					},
				},
				swap = {
					enable = true,
					swap_next = {
						[">k"] = { query = "@block.outer", desc = "Swap next block" },
						[">f"] = { query = "@function.outer", desc = "Swap next function" },
						[">a"] = { query = "@parameter.inner", desc = "Swap next argument" },
					},
					swap_previous = {
						["<k"] = { query = "@block.outer", desc = "Swap previous block" },
						["<f"] = { query = "@function.outer", desc = "Swap previous function" },
						["<a"] = { query = "@parameter.inner", desc = "Swap previous argument" },
					},
				},
			},
		},
	},
}
