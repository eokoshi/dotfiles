-- if true then return {} end

local function has_words_before()
	local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
	"Saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	version = "1.*", -- make sure to always set version to v1 even on development
	event = { "InsertEnter", "CmdlineEnter" },
	opts_extend = { "sources.default", "sources.providers" },
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		completion = {
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
								return ctx.kind_hl
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 300,
				window = {
					border = "rounded",
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
				},
			},
		},
		signature = { enabled = false },
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "lazydev" },
			providers = {
				path = {
					opts = {
						get_cwd = function(_)
							return vim.fn.getcwd()
						end,
					},
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
				cmdline = {
					module = "blink.cmp.sources.cmdline",
					-- Disable shell commands on windows, since they cause neovim to hang
					enabled = function()
						return vim.fn.has("win32") == 0 or vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
					end,
				},
			},
		},
		cmdline = {
			enabled = true, -- set to false if you want noice popupmenu (or wait for noice to get blink compatibility)
			sources = function()
				local type = vim.fn.getcmdtype()
				if
					vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
					or vim.fn.getcmdline():match("^[%%0-9,'<>%-]*term")
					or vim.fn.getcmdline():match("^[%%0-9,'<>%-]*terminal")
				then
					return {}
				elseif type == "/" or type == "?" then
					return { "buffer" }
				elseif type == ":" or type == "@" then
					return { "cmdline" }
				end
				return {}
			end,
			completion = {
				ghost_text = { enabled = false },
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
				function(cmp)
					if has_words_before() or vim.api.nvim_get_mode().mode == "c" then
						return cmp.show()
					end
				end,
				"fallback",
			},
			["<S-Tab>"] = {
				"select_prev",
				"snippet_backward",
				function(cmp)
					if vim.api.nvim_get_mode().mode == "c" then
						return cmp.show()
					end
				end,
				"fallback",
			},
		},
	},
}
