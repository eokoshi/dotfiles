return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		{
			"mikavilpas/blink-ripgrep.nvim",
			version = "*", -- use the latest stable version
		},
	},
	version = "*",
	event = { "InsertEnter", "CmdlineEnter" },
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		completion = {
			keyword = {
				range = "full",
			},
			trigger = {
				show_in_snippet = false,
				show_on_blocked_trigger_characters = function()
					if vim.bo.filetype == "markdown" then
						return { " ", "\n", "\t", ".", "/", "(", "[" }
					end
					return { " ", "\n", "\t" }
				end,
			},
			list = {
				selection = {
					preselect = true,
					auto_insert = true,
				},
			},
			accept = {
				auto_brackets = { enabled = true },
			},
			menu = {
				border = "shadow",
				scrollbar = true,
				auto_show = true,
				draw = {
					align_to = "none",
					cursorline_priority = 0,
					treesitter = { "lsp" },
					columns = {
						{ "kind_icon" },
						{ "label" },
						{ "source_name" },
					},
					components = {
						source_name = {
							width = { max = 30 },
							text = function(ctx)
								return ctx.source_name
							end,
							highlight = function(ctx)
								if ctx.source_name == "rg" then
									return "BlinkCmpKindKeyword"
								else
									return ctx.kind_hl
								end
							end,
						},
						kind_icon = {
							text = function(ctx)
								if ctx.source_name == "rg" then
									local kind_icon = ""
									return kind_icon
								else
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end
							end,
							-- (optional) use highlights from mini.icons
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
						kind = {
							-- (optional) use highlights from mini.icons
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 300,
				window = {
					border = "single",
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
				},
			},
			-- ghost_text = {
			-- 	enabled = true,
			-- },
		},
		signature = { enabled = false },
		sources = {
			default = function()
				local success, node = pcall(vim.treesitter.get_node)
				if
					success
					and node
					and vim.tbl_contains({
						"comment",
						"line_comment",
						"block_comment",
						"string",
						"word",
						"raw_string",
					}, node:type())
				then
					return { "lsp", "buffer", "path", "ripgrep" }
				elseif vim.bo.filetype == "lua" then
					return { "lazydev", "lsp", "buffer", "snippets", "ripgrep" }
				else
					return { "lsp", "buffer", "snippets", "ripgrep" }
				end
			end,
			providers = {
				path = {
					opts = {
						get_cwd = function(_)
							return vim.fn.getcwd()
						end,
					},
				},
				lsp = {
					score_offset = 10,
				},
				ripgrep = {
					module = "blink-ripgrep",
					name = "rg",
					---@module "blink-ripgrep"
					---@type blink-ripgrep.Options
					opts = {
						prefix_min_len = 3,
						backend = {
							use = "gitgrep-or-ripgrep",
						},
					},
					score_offset = -1,
					async = true,
					should_show_items = function(ctx)
						return ctx.trigger.initial_kind ~= "trigger_character"
					end,
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100, -- show at a higher priority than lsp
				},
			},
		},
		cmdline = {
			keymap = {
				preset = "inherit",
				["<CR>"] = { "accept_and_enter", "fallback" },
			},
			completion = {
				menu = { auto_show = true },
				list = {
					selection = {
						preselect = false,
					},
				},
			},
		},
		keymap = {
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-p>"] = { "scroll_documentation_up", "fallback" },
			["<C-n>"] = { "scroll_documentation_down", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = {
				"select_next",
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = {
				"select_prev",
				"snippet_backward",
				"fallback",
			},
		},
	},
}
