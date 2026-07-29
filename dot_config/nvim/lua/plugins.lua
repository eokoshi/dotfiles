local icons = require("stuff.icons")
local map = require("stuff.functions").map

return {
	-- ===
	-- Completion
	{
		{
			"saghen/blink.cmp",
			version = "1.*",
			dependencies = {
				"rafamadriz/friendly-snippets",
				{
					"mikavilpas/blink-ripgrep.nvim",
					version = "*",
				},
			},
			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				enabled = function() return vim.b.completion or vim.b.completion == nil end,
				keymap = {
					["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
					["<C-e>"] = { "cancel", "fallback" },
					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },
					["<C-p>"] = { "scroll_documentation_up", "fallback" },
					["<C-n>"] = { "scroll_documentation_down", "fallback" },
					["<CR>"] = { "accept", "fallback" },
					["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
					["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				},
				completion = {
					trigger = {
						show_in_snippet = false,
						show_on_blocked_trigger_characters = function()
							if vim.bo.filetype == "markdown" then return { " ", "\n", "\t", ".", "/", "(", "[" } end
							return { " ", "\n", "\t" }
						end,
					},
					list = {
						max_items = 25,
						selection = {
							preselect = true,
							auto_insert = false,
						},
					},
					menu = {
						border = "none",
						auto_show_delay_ms = 150,
						draw = {
							columns = { { "kind_icon" }, { "label" }, { "source_name" } },
							components = {
								source_name = {
									highlight = function(ctx) return ctx.kind_hl end,
								},
							},
						},
					},
					documentation = {
						auto_show_delay_ms = 300,
						window = {
							border = "single",
							winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
						},
					},
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
					providers = {
						lsp = {
							score_offset = 10,
							async = true,
						},
						path = {
							opts = {
								get_cwd = function(_) return vim.fn.getcwd() end,
							},
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
									ripgrep = {
										context_size = 3,
										max_filesize = "5K",
									},
								},
							},
							score_offset = -1,
							async = true,
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
						ghost_text = { enabled = false },
					},
				},
			},
			opts_extend = { "sources.default" },
		},
	},

	-- ===
	-- Markdown
	{
		{
			"bngarren/checkmate.nvim",
			ft = "markdown",
			opts = {
				files = { "*.md", "todo", "*.todo", "TODO" },
				todo_states = {
					checked = {
						marker = "󰸞",
					},
				},
				keys = false,
				default_list_marker = "*",
				metadata = {
					priority = {
						style = function(context)
							local value = context.value:lower()
							if value == "high" then
								return { fg = "#ff5555", bold = true }
							elseif value == "medium" then
								return { fg = "#ffb86c" }
							elseif value == "low" then
								return { fg = "#8be9fd" }
							else
								return { fg = "#8be9fd" }
							end
						end,
						get_value = function() return "medium" end,
						choices = function() return { "low", "medium", "high" } end,
						key = "<leader>mcp",
						sort_order = 10,
						jump_to_on_insert = "value",
						select_on_insert = true,
					},
					started = {
						aliases = { "init" },
						style = { fg = "#9fd6d5" },
						get_value = function() return tostring(os.date("%Y%m%d %H:%M")) end,
						key = "<leader>mcs",
						sort_order = 20,
					},
					done = {
						aliases = { "completed", "finished" },
						style = { fg = "#96de7a" },
						get_value = function() return tostring(os.date("%Y%m%d %H:%M")) end,
						on_add = function(todo_item) require("checkmate").set_todo_state(todo_item, "checked") end,
						on_remove = function(todo_item) require("checkmate").set_todo_state(todo_item, "unchecked") end,
						sort_order = 30,
					},
					due = {
						aliases = { "deadline", "by", "until", "duedate" },
						key = "<leader>mcd",
						get_value = function() return tostring(os.date("%Y%m%d", os.time() + (24 * 60 * 60 * 2))) end,
						jump_to_on_insert = "value",
						select_on_insert = true,
						style = function(context)
							local duedate = os.time({
								year = context.value:sub(1, 4),
								month = context.value:sub(5, 6),
								day = context.value:sub(7, 8),
							})
							local remaining = os.difftime(os.time(), duedate) / (24 * 60 * 60)
							if remaining > 0 then
								return { sp = "red", undercurl = true }
							elseif remaining > -1 then
								return { bg = "#ff5555", bold = true }
							elseif remaining > -7 then
								return { bg = "#ff6700", bold = true }
							elseif remaining > -14 then
								return { bg = "orange" }
							elseif remaining > -21 then
								return { bg = "gold" }
							elseif remaining > -28 then
								return { bg = "greenyellow" }
							else
								return { fg = "green" }
							end
						end,
						sort_order = 15,
					},
				},
			},
			init = function()
				vim.api.nvim_create_autocmd("FileType", {
					pattern = "markdown",
					callback = function()
						map({ "n", "v" }, "<CR>", "<cmd>Checkmate metadata toggle done<CR>", { desc = "Toggle todo item", buffer = true })
						map({ "n", "v" }, "<leader>mc", "", { desc = "Checkmate", buffer = true })
						map({ "n", "v" }, "<leader>mc+", "<cmd>Checkmate cycle_next<CR>", { desc = "Cycle todo item(s) to the next state", buffer = true })
						map(
							{ "n", "v" },
							"<leader>mc-",
							"<cmd>Checkmate cycle_previous<CR>",
							{ desc = "Cycle todo item(s) to the previous state", buffer = true }
						)
						map({ "n", "v" }, "<leader>mcn", "<cmd>Checkmate create<CR>", { desc = "Create todo item", buffer = true })
						map({ "n", "v" }, "<leader>mcr", "<cmd>Checkmate remove<CR>", { desc = "Remove todo marker (convert to text)", buffer = true })
						map(
							{ "n", "v" },
							"<leader>mcR",
							"<cmd>Checkmate remove_all_metadata<CR>",
							{ desc = "Remove all metadata from a todo item", buffer = true }
						)
						map(
							{ "n" },
							"<leader>mca",
							"<cmd>Checkmate archive<CR>",
							{ desc = "Archive checked/completed todo items (move to bottom section)", buffer = true }
						)
						map(
							{ "n" },
							"<leader>mcv",
							"<cmd>Checkmate metadata select_value<CR>",
							{ desc = "Update the value of a metadata tag under the cursor", buffer = true }
						)
						map({ "n" }, "<leader>mc]", "<cmd>Checkmate metadata jump_next<CR>", { desc = "Move cursor to next metadata tag", buffer = true })
						map({ "n" }, "<leader>mc[", "<cmd>Checkmate metadata jump_previous<CR>", { desc = "Move cursor to previous metadata tag", buffer = true })
					end,
				})
			end,
		},
		{
			"obsidian-nvim/obsidian.nvim",
			version = "*",
			cmd = "Obsidian",
			enabled = vim.fn.has("win32") == 1,
			---@module 'obsidian'
			---@diagnostic disable-next-line: type-not-found
			---@type obsidian.config
			opts = function()
				return {
					legacy_commands = false,
					statusline = { enabled = false },
					new_notes_location = "current_dir",
					link = { auto_update = true },
					workspaces = {
						{
							name = "personal",
							path = "~/Documents/Obsidian",
						},
					},
					---@diagnostic disable-next-line: unresolved-require
					note_id_func = require("obsidian.builtin").title_id,
					templates = { folder = "Templates" },
					picker = { name = "snacks.picker" },
					daily_notes = {
						folder = "Daily Notes",
						template = "Templates/dailynote.md",
					},
					ui = { enabled = false },
					attachments = { folder = "Images" },
					footer = { enabled = false },
					checkbox = { enabled = false },
				}
			end,
			init = function()
				map("n", "<Leader>mt", "<CMD>Obsidian today<CR>", { desc = "today's note" })
				map("n", "<Leader>my", "<CMD>Obsidian yesterday<CR>", { desc = "yesterday's note" })
				map("n", "<Leader>md", "<CMD>Obsidian dailies -48 0<CR>", { desc = "find daily notes" })
				map("n", "<Leader>mn", "<CMD>Obsidian new_from_template<CR>", { desc = "new from template" })
				map("n", "<leader>mo", "<CMD>cd ~/Documents/Obsidian<CR>", { desc = "cd vault" })

				vim.api.nvim_create_autocmd("User", {
					pattern = "ObsidianNoteEnter",
					callback = function()
						vim.keymap.set("n", "<CR>", function()
							---@diagnostic disable-next-line: unresolved-require
							local M = require("obsidian.api")
							if M.cursor_link() then
								return "<cmd>Obsidian follow_link<cr>"
							elseif M.cursor_tag() then
								return "<cmd>Obsidian tags<cr>"
							elseif M.cursor_heading() then
								return "za"
							else
								return "<cmd>Checkmate metadata toggle done<cr>"
							end
						end, {
							expr = true,
							buffer = true,
							desc = "smart action",
						})
					end,
				})

				vim.api.nvim_create_autocmd("DirChangedPre", {
					pattern = "global",
					callback = function()
						---@diagnostic disable-next-line: undefined-field
						if string.match(vim.v.event.directory, "\\Obsidian") then
							vim.system(
								{ "git", "pull" },
								---@diagnostic disable-next-line: param-type-mismatch
								{
									cwd = vim.fn.expand("$HOME/Documents/Obsidian"),
									text = true,
								},
								vim.schedule_wrap(function(obj)
									if obj.stdout ~= nil then
										vim.notify(obj.stdout, vim.log.levels.INFO, { title = "Git pull", style = "minimal" })
									elseif obj.stderr ~= nil then
										vim.notify(obj.stdout, vim.log.levels.ERROR, { title = "Git pull" })
									end
								end)
							)
						end
					end,
				})
			end,
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			version = "*",
			ft = { "markdown", "ipynb", "codecompanion" },
			---@module 'render-markdown'
			---@type render.md.UserConfig
			opts = {
				heading = {
					sign = false,
					position = "inline",
					icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
				},
				code = {
					sign = false,
					position = "right",
					width = "block",
					right_pad = 1,
					min_width = 84,
					border = "thick",
					language_right = "█",
				},
				checkbox = { enabled = false },
				latex = { enabled = false },
				win_options = {
					conceallevel = {
						default = vim.api.nvim_get_option_value("conceallevel", {}),
						rendered = 2,
					},
				},
			},
		},
		{
			"jbyuki/nabla.nvim",
			ft = "markdown",
		},
		{
			-- "OXY2DEV/markview.nvim",
			-- lazy = false,
			-- ---@module "markview"
			-- ---@type markview.config
			-- opts = {
			-- 	preview = {
			-- 		icon_provider = "mini",
			-- 		hybrid_modes = { "n", "no", "c", "t" },
			-- 		enable_hybrid_mode = true,
			-- 		linewise_hybrid_mode = true,
			-- 	},
			-- 	markdown = {
			-- 		headings = { shift_width = 0 },
			-- 		list_items = {
			-- 			marker_minus = { add_padding = false },
			-- 			marker_star = { add_padding = false, text = "-" },
			-- 		},
			-- 		tables = {
			-- 			parts = {
			-- 				top = { "╭", "─", "╮", "┬" },
			-- 				header = { "│", "│", "│" },
			-- 				separator = { "├", "─", "┤", "┼" },
			-- 				row = { "│", "│", "│" },
			-- 				bottom = { "╰", "─", "╯", "┴" },
			-- 				overlap = { "┝", "━", "┥", "┿" },
			-- 				align_left = "╼",
			-- 				align_right = "╾",
			-- 				align_center = { "╴", "╶" },
			-- 			},
			-- 		},
			-- 	},
			-- 	markdown_inline = {
			-- 		checkboxes = { enable = false },
			-- 	},
			-- 	latex = { enable = false },
		},
	},

	-- ===
	-- Colorschemes
	{
		{
			"olimorris/onedarkpro.nvim",
			lazy = true,
			opts = {
				styles = {
					comments = "italic",
					keywords = "bold, italic",
					conditionals = "italic",
				},
				highlights = {
					NormalFloat = { link = "Normal" },
					FloatBorder = { link = "UltestBorder" },
				},
			},
		},
		{
			"sainnhe/everforest",
			lazy = true,
			init = function()
				vim.g.everforest_background = "medium"
				vim.g.everforest_better_performance = 1
				vim.g.everforest_enable_italic = 1
			end,
		},
		{
			"sainnhe/gruvbox-material",
			lazy = true,
			init = function()
				vim.g.gruvbox_material_foreground = "material"
				vim.g.gruvbox_material_background = "medium"
				vim.g.gruvbox_material_enable_italic = 1
				vim.g.gruvbox_material_enable_bold = 1
				vim.g.gruvbox_better_performance = 1
				vim.g.gruvbox_material_transparent_background = 1
			end,
		},
		-- { "sainnhe/edge", lazy = true, init = function() vim.g.edge_style = "default" vim.g.edge_better_performance = 1 vim.g.edge_enable_italic = 1 end, },
		-- { "mcauley-penney/techbase.nvim", lazy = true, opts = { italic_comments = false, transparent = false, plugin_support = { blink = true, gitsigns = true, lazy = true, lualine = true, mason = true, }, hl_overrides = {}, }, },
		-- { "astronvim/astrotheme", lazy = true, opts = {} },
		-- { "ribru17/bamboo.nvim", lazy = true, opts = {} },
		-- { "rebelot/kanagawa.nvim", lazy = true, opts = {} },
		-- { "folke/tokyonight.nvim", lazy = true, opts = {} },
		-- { "sainnhe/sonokai", lazy = true },
		-- { "gbprod/nord.nvim", lazy = true },
		-- { "rose-pine/neovim", name = "rose-pine", lazy = true },
	},

	-- ===
	-- Formatters
	{
		{
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					"<leader>bf",
					function() require("conform").format({ async = true }) end,
					mode = "n",
					desc = "format buffer",
				},
			},
			---@module "conform"
			---@type conform.setupOpts
			opts = {
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
					r = { "air" },
					htmldjango = { "djlint" },
					yaml = { "prettier" },
					json = { "fixjson", "prettier" },
					css = { "prettier" },
					javascript = { "prettier" },
					gotmpl = { "shfmt" },
				},
				default_format_opts = {
					lsp_format = "fallback",
				},
				format_on_save = function(bufnr)
					if vim.b[bufnr].autoformat or vim.b[bufnr].autoformat == nil then return { timeout_ms = 500, lsp_format = "fallback" } end
				end,
				formatters = {
					ruff_format = {
						append_args = { "--extension", "ipynb:python" },
					},
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
				},
			},
			init = function()
				map("n", "<Leader>lc", "<CMD>ConformInfo<CR>", { desc = "Formatter info" })
				vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

				vim.api.nvim_create_user_command("FormatDisable", function() vim.b.autoformat = false end, { desc = "Disable autoformat-on-save" })
				vim.api.nvim_create_user_command("FormatEnable", function() vim.b.autoformat = true end, { desc = "Enable autoformat-on-save" })
			end,
		},
	},

	-- ===
	-- Debugger UI
	{
		{
			"mfussenegger/nvim-dap-python",
			ft = { "python" },
			dependencies = {
				{ "mfussenegger/nvim-dap" },
				{
					"igorlfs/nvim-dap-view",
					version = "*",
					---@module 'dap-view'
					---@type dapview.Config
					opts = {
						winbar = {
							sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
							default_section = "scopes",
						},
						windows = {
							terminal = {
								position = "right",
							},
						},
						auto_toggle = "keep_terminal",
					},
				},
			},
			config = function()
				require("dap-python").setup("uv")
				local dap = require("dap")
				dap.defaults.fallback.stepping_granularity = "line"
				dap.defaults.fallback.auto_continue_if_many_stopped = false
				map("n", "<F5>", function() dap.continue() end, { desc = "Debugger: Start" })
				map("n", "<F17>", function() dap.terminate() end, { desc = "Debugger: Stop" })
				map("n", "<F29>", function() dap.restart_frame() end, { desc = "Debugger: Restart" })
				map("n", "<F6>", function() dap.pause() end, { desc = "Debugger: Pause" })
				map("n", "<F9>", function() dap.toggle_breakpoint() end, { desc = "Debugger: Toggle Breakpoint" })
				map("n", "<F10>", function() dap.step_over() end, { desc = "Debugger: Step Over" })
				map("n", "<F11>", function() dap.step_into() end, { desc = "Debugger: Step Into" })
				map("n", "<F23>", function() dap.step_out() end, { desc = "Debugger: Step Out" })
				map("n", "<Leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint (F9)" })
				map("n", "<Leader>dB", function() dap.clear_breakpoints() end, { desc = "Clear Breakpoints" })
				map("n", "<Leader>dc", function() dap.continue() end, { desc = "Start/Continue (F5)" })
				map("n", "<Leader>dh", function() require("dap.ui.widgets").hover() end, { desc = "Debugger Hover" })
				map("n", "<Leader>di", function() dap.step_into() end, { desc = "Step Into (F11)" })
				map("n", "<Leader>dj", "<CMD>e $PWD/.vscode/launch.json<CR><CMD>w ++p<CR>", { desc = "Open workspace DAP config" })
				map("n", "<Leader>do", function() dap.step_over() end, { desc = "Step Over (F10)" })
				map("n", "<Leader>dO", function() dap.step_out() end, { desc = "Step Out (S-F11)" })
				map("n", "<Leader>dp", function() dap.pause() end, { desc = "Pause (F6)" })
				map("n", "<Leader>dq", function() dap.close() end, { desc = "Close Session" })
				map("n", "<Leader>dQ", function() dap.terminate() end, { desc = "Terminate Session (S-F5)" })
				map("n", "<Leader>dr", function() dap.restart_frame() end, { desc = "Restart (C-F5)" })
				map("n", "<Leader>dR", function() dap.repl.toggle() end, { desc = "Toggle REPL" })
				map("n", "<Leader>dt", function() require("dap-view").show_view("console") end, { desc = "Show Console" })
				map("n", "<Leader>ds", function() dap.run_to_cursor() end, { desc = "Run To Cursor" })
				map("n", "<F21>", function()
					vim.ui.input({ prompt = "Condition: " }, function(cond)
						if cond then dap.set_breakpoint(cond) end
					end)
				end, { desc = "Debugger: Conditional Breakpoint" })
				map("n", "<Leader>dC", function()
					vim.ui.input({ prompt = "Condition: " }, function(cond)
						if cond then dap.set_breakpoint(cond) end
					end)
				end, { desc = "Conditional Breakpoint (S-F9)" })
				map("n", "<Leader>du", function() require("dap-view").toggle(true) end, { desc = "Toggle Debugger UI" })
			end,
		},
	},

	-- ===
	-- Git
	{
		{
			"lewis6991/gitsigns.nvim",
			event = "VeryLazy",
			opts = {
				current_line_blame_opts = {
					delay = 300,
				},
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")
					if vim.api.nvim_buf_get_name(bufnr):match("%.ipynb$") then return false end

					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							require("gitsigns").nav_hunk("next")
						end
					end, { desc = "Next hunk", buffer = bufnr })
					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							require("gitsigns").nav_hunk("prev")
						end
					end, { desc = "Prev hunk", buffer = bufnr })

					map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk", buffer = bufnr })
					map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk", buffer = bufnr })
					map("v", "<leader>gs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk", buffer = bufnr })
					map("v", "<leader>gr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk", buffer = bufnr })
					map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer", buffer = bufnr })
					map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer", buffer = bufnr })
					map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk", buffer = bufnr })
					map("n", "<leader>gP", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline", buffer = bufnr })
					map("n", "<leader>gx", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame line", buffer = bufnr })
					map("n", "<leader>gX", gitsigns.blame, { desc = "Blame", buffer = bufnr })
					map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff file", buffer = bufnr })
					map("n", "<leader>gq", gitsigns.setqflist, { desc = "Quickfix file changes", buffer = bufnr })
					map("n", "<leader>gQ", function() gitsigns.setqflist("all") end, { desc = "Quickfix all changes", buffer = bufnr })
					map("n", "<leader>gc", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame", buffer = bufnr })
					map("n", "<leader>gw", gitsigns.toggle_word_diff, { desc = "Toggle word diff", buffer = bufnr })
					map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "inside hunk", buffer = bufnr })
					map({ "o", "x" }, "ah", gitsigns.select_hunk, { desc = "around hunk", buffer = bufnr })
				end,
			},
		},
		{
			"esmuellert/codediff.nvim",
			cmd = "CodeDiff",
			opts = {
				diff = {
					compute_moves = true,
				},
				keymaps = {
					view = {
						toggle_explorer = "<leader>e",
						focus_explorer = false,
						stage_hunk = "<leader>gs",
						unstage_hunk = "<leader>gu",
						discard_hunk = "<leader>gr",
						show_help = "?",
					},
				},
			},
		},
		{
			-- "sindrets/diffview.nvim", cmd = "DiffviewOpen", keys = { { "<Leader>gD", mode = { "n" }, "<CMD>DiffviewOpen<CR>", desc = "Diff repo" }, { "<Leader>gh", mode = { "n" }, "<CMD>DiffviewFileHistory %<CR>", desc = "History: file" }, { "<Leader>gH", mode = { "n" }, "<CMD>DiffviewFileHistory<CR>", desc = "History: repo" }, }, config = function() local actions = require("diffview.actions") require("diffview").setup({ enhanced_diff_hl = true, view = { default = { disable_diagnostics = true, winbar_info = true, }, merge_tool = { layout = "diff3_mixed", }, }, file_panel = { win_config = { position = "bottom", height = 10, }, }, file_history_panel = { win_config = { type = "split", position = "bottom", height = 10, }, }, keymaps = { disable_defaults = true, view = { { "n", "<Leader>q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } }, { "n", "<Leader>e", actions.toggle_files, { desc = "toggle file panel" } }, { "n", "gf", actions.goto_file_edit, { desc = "Open file in previous tabpage" } }, { "n", "g?", actions.help("view"), { desc = "Open help panel" } }, { "n", "co", actions.conflict_choose("ours"), { desc = "Choose conflict --ours" } }, { "n", "ct", actions.conflict_choose("theirs"), { desc = "Choose conflict --theirs" } }, { "n", "cb", actions.conflict_choose("base"), { desc = "Choose conflict --base" } }, { "n", "ca", actions.conflict_choose("all"), { desc = "Choose conflict --all" } }, { "n", "cn", actions.conflict_choose("none"), { desc = "Choose conflict --none" } }, }, file_panel = { { "n", "q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } }, { "n", "<Leader>e", actions.toggle_files, { desc = "toggle file panel" } }, { "n", "j", actions.next_entry, { desc = "Next file entry" } }, { "n", "<down>", actions.select_next_entry, { desc = "Select next file entry" } }, { "n", "k", actions.prev_entry, { desc = "Previous file entry" } }, { "n", "<up>", actions.select_prev_entry, { desc = "Select previous file entry" } }, { "n", "<cr>", actions.select_entry, { desc = "Open diff for selected entry" } }, { "n", "s", actions.toggle_stage_entry, { desc = "Stage/unstage entry" } }, { "n", "S", actions.stage_all, { desc = "Stage all entries" } }, { "n", "U", actions.unstage_all, { desc = "Unstage all entries" } }, { "n", "[x", actions.prev_conflict, { desc = "Go to prev conflict" } }, { "n", "]x", actions.next_conflict, { desc = "Go to next conflict" } }, { "n", "gf", actions.goto_file_edit, { desc = "Open file in previous tabpage" } }, { "n", "co", actions.conflict_choose_all("ours"), { desc = "Choose conflict --ours" } }, { "n", "ct", actions.conflict_choose_all("theirs"), { desc = "Choose conflict --theirs" } }, { "n", "cb", actions.conflict_choose_all("base"), { desc = "Choose conflict --base" } }, { "n", "l", actions.open_fold, { desc = "Expand fold" } }, { "n", "h", actions.close_fold, { desc = "Collapse fold" } }, { "n", "t", actions.listing_style, { desc = "Toggle list/tree views" } }, { "n", "L", actions.open_commit_log, { desc = "Open commit log panel" } }, { "n", "g?", actions.help("file_panel"), { desc = "Open help panel" } }, { "n", "cc", function() vim.ui.input({ prompt = "Commit message: " }, function(msg) if not msg then return end local results = vim.system({ "git", "commit", "-m", msg }, { text = true }):wait() vim.notify(results.stdout, vim.log.levels.INFO, { title = "Commit" }) end) end, }, { "n", "cx", function() local results = vim.system({ "git", "commit", "--amend", "--no-edit" }, { text = true }):wait() vim.notify(results.stdout, vim.log.levels.INFO, { title = "Commit amend" }) end, }, }, file_history_panel = { { "n", "q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } }, { "n", "<Leader>e", actions.toggle_files, { desc = "toggle file panel" } }, { "n", "j", actions.next_entry, { desc = "Next log entry" } }, { "n", "<down>", actions.select_next_entry, { desc = "Select next log entry" } }, { "n", "k", actions.prev_entry, { desc = "Previous log entry" } }, { "n", "<up>", actions.select_prev_entry, { desc = "Select previous file entry" } }, { "n", "<cr>", actions.select_entry, { desc = "Open diff for selected entry" } }, { "n", "gd", actions.open_in_diffview, { desc = "Open entry in diffview" } }, { "n", "y", actions.copy_hash, { desc = "Copy commit hash" } }, { "n", "L", actions.open_commit_log, { desc = "Show commit details" } }, { "n", "gf", actions.goto_file_edit, { desc = "Open file in previous tabpage" } }, { "n", "g?", actions.help("file_history_panel"), { desc = "Open help panel" } }, }, help_panel = { { "n", "q", actions.close, { desc = "Close help menu" } }, { "n", "<ESC>", actions.close, { desc = "Close help menu" } }, }, }, }) end,
		},
	},

	-- ===
	-- Filesystem
	{
		{
			"nvim-mini/mini.files",
			opts = {
				options = {
					permanent_delete = false,
				},
				windows = {
					preview = false,
					width_preview = 90,
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
			},
			init = function()
				local _, MiniFiles = pcall(require, "mini.files")
				if not MiniFiles then return end
				local nsMiniFiles = vim.api.nvim_create_namespace("mini_files_git")

				-- Cache for git status
				local gitStatusCache = {}
				local cacheTimeout = 2000 -- in milliseconds
				local uv = vim.uv

				local function isSymlink(path)
					local stat = uv.fs_lstat(path)
					return stat and stat.type == "link"
				end

				---@param status string
				---@return string symbol, string hlGroup
				local function mapSymbols(status, is_symlink)
					local statusMap = {
						[" M"] = { symbol = "•", hlGroup = "MiniDiffSignChange" }, -- Modified in the working directory
						["M "] = { symbol = "", hlGroup = "MiniDiffSignChange" }, -- modified in index
						["MM"] = { symbol = "≠", hlGroup = "MiniDiffSignChange" }, -- modified in both working tree and index
						["A "] = { symbol = "+", hlGroup = "MiniDiffSignAdd" }, -- Added to the staging area, new file
						["AA"] = { symbol = "≈", hlGroup = "MiniDiffSignAdd" }, -- file is added in both working tree and index
						["D "] = { symbol = "D", hlGroup = "MiniDiffSignDelete" }, -- Deleted from the staging area
						[" D"] = { symbol = "D", hlGroup = "MiniDiffSignDelete" }, -- Deleted from the staging area
						["AM"] = { symbol = "⊕", hlGroup = "MiniDiffSignChange" }, -- added in working tree, modified in index
						["AD"] = { symbol = "⯢", hlGroup = "MiniDiffSignChange" }, -- Added in the index and deleted in the working directory
						["R "] = { symbol = "→", hlGroup = "MiniDiffSignChange" }, -- Renamed in the index
						["U "] = { symbol = "‖", hlGroup = "MiniDiffSignChange" }, -- Unmerged path
						["UU"] = { symbol = "⇄", hlGroup = "MiniDiffSignAdd" }, -- file is unmerged
						["UA"] = { symbol = "⊕", hlGroup = "MiniDiffSignAdd" }, -- file is unmerged and added in working tree
						["??"] = { symbol = "?", hlGroup = "Macro" }, -- Untracked files
						["!!"] = { symbol = "", hlGroup = "Ignore" }, -- Ignored files
					}
					local result = statusMap[status] or { symbol = "?", hlGroup = "NonText" }
					local gitSymbol = result.symbol
					local gitHlGroup = result.hlGroup
					local symlinkSymbol = is_symlink and "↩" or ""
					local combinedSymbol = (symlinkSymbol .. gitSymbol):gsub("^%s+", ""):gsub("%s+$", "")
					local combinedHlGroup = is_symlink and "MiniDiffSignDelete" or gitHlGroup
					return combinedSymbol, combinedHlGroup
				end

				---@param cwd string
				---@param callback function
				---@return nil
				local function fetchGitStatus(cwd, callback)
					local clean_cwd = cwd:gsub("^minifiles://%d+/", "")
					---@param content table
					local function on_exit(content)
						if content.code == 0 then callback(content.stdout) end
					end
					vim.system({ "git", "status", "-uall", "--ignored=matching", "--porcelain" }, { text = true, cwd = clean_cwd }, on_exit)
				end

				local function inArray(array, x)
					if not array then return false end
					for _, v in ipairs(array) do
						if v == x then return true end
					end
					return false
				end

				---@param buf_id integer
				---@param gitStatusMap table
				---@return nil
				local function updateMiniWithGit(buf_id, gitStatusMap)
					vim.g.tmp = gitStatusMap
					vim.schedule(function()
						local nlines = vim.api.nvim_buf_line_count(buf_id)
						local cwd = vim.fs.root(buf_id, ".git")
						local escapedcwd = cwd and vim.pesc(cwd)
						---@diagnostic disable-next-line: param-type-mismatch
						escapedcwd = vim.fs.normalize(escapedcwd)
						for i = 1, nlines do
							local entry = MiniFiles.get_fs_entry(buf_id, i)
							if not entry then break end
							local relativePath = entry.path:gsub("^" .. escapedcwd .. "/", "")
							local status_tbl = gitStatusMap[relativePath]

							-- handle children of ignored dirs
							if not status_tbl then
								local checkPath = relativePath
								while true do
									checkPath = checkPath:match("^(.*)/[^/]+$")
									if not checkPath then break end
									if inArray(gitStatusMap[checkPath], "!!") then
										status_tbl = { "!!" }
										break
									end
								end
							end
							if status_tbl then
								for j, status in ipairs(status_tbl) do
									local symbol, hlGroup = mapSymbols(status, isSymlink(entry.path))
									vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, j, {
										virt_text = { { symbol, hlGroup } },
										virt_text_pos = "right_align",
										hl_mode = "combine",
									})
									local line = vim.api.nvim_buf_get_lines(buf_id, i - 1, i, false)[1]
									local nameStartCol = line--[[@cast -?]]:find(vim.pesc(entry.name)) or 0
									if nameStartCol > 0 then
										vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, nameStartCol - 1, {
											end_col = nameStartCol + #entry.name - 1,
											hl_group = hlGroup,
										})
									end
								end
							end
						end
					end)
				end

				---@param content string
				---@return table
				local function parseGitStatus(content)
					local gitStatusMap = {}
					for line in content:gmatch("[^\r\n]+") do
						local status, filePath = string.match(line, "^(..)%s+(.*)")
						---@diagnostic disable-next-line: param-type-mismatch
						if status == "R " then filePath = string.match(filePath, "^.*%s%-%>%s(.*)") end
						local parts = {}
						for part in
							filePath--[[@cast -?]]:gmatch("[^/]+")
						do
							table.insert(parts, part)
						end
						local currentKey = ""
						for i, part in ipairs(parts) do
							if i > 1 then
								currentKey = currentKey .. "/" .. part
							else
								currentKey = part
							end
							if i == #parts then
								gitStatusMap[currentKey] = { status }
							elseif gitStatusMap[currentKey] and not inArray(gitStatusMap[currentKey], status) and status ~= "!!" then
								table.insert(gitStatusMap[currentKey], status)
							else
								if status ~= "!!" then gitStatusMap[currentKey] = { status } end
							end
						end
					end
					return gitStatusMap
				end

				---@param buf_id integer
				---@return nil
				local function updateGitStatus(buf_id)
					local cwd = vim.fs.root(buf_id, ".git")
					if not cwd then return end
					local currentTime = os.time()
					if gitStatusCache[cwd] and currentTime - gitStatusCache[cwd].time < cacheTimeout then
						updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
					else
						fetchGitStatus(cwd, function(content)
							local gitStatusMap = parseGitStatus(content)
							gitStatusCache[cwd] = {
								time = currentTime,
								statusMap = gitStatusMap,
							}
							updateMiniWithGit(buf_id, gitStatusMap)
						end)
					end
				end

				---@return nil
				local function clearCache() gitStatusCache = {} end
				local function augroup(name) return vim.api.nvim_create_augroup("MiniFiles_" .. name, { clear = true }) end
				vim.api.nvim_create_autocmd("User", {
					group = augroup("close"),
					pattern = "MiniFilesExplorerClose",
					callback = function() clearCache() end,
				})
				vim.api.nvim_create_autocmd("User", {
					group = augroup("update"),
					pattern = "MiniFilesBufferUpdate",
					callback = function(args)
						local bufnr = args.data.buf_id
						local cwd = vim.fs.root(bufnr, ".git")
						if not cwd then return end
						if gitStatusCache[cwd] then
							updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
						else
							updateGitStatus(bufnr)
						end
					end,
				})

				local minifiles_toggle = function(...)
					if not MiniFiles.close() then MiniFiles.open(...) end
				end
				local yank_path = function()
					local path = (MiniFiles.get_fs_entry() or {}).path
					if path == nil then return vim.notify("Cursor is not on valid entry") end
					if vim.fs.relpath(vim.fn.getcwd(), path) then
						path = "./" .. vim.fs.relpath(vim.fn.getcwd(), path)
					elseif vim.fs.relpath("~", path) and vim.fs.relpath("~", path) ~= "." then
						path = "~/" .. vim.fs.relpath("~", path)
					end
					vim.notify("yanked: " .. path)
					vim.fn.setreg(vim.v.register, path)
				end
				local set_cwd = function()
					local path = (MiniFiles.get_fs_entry() or {}).path
					if path == nil then return vim.notify("Cursor is not on valid entry") end
					local dir = vim.fs.dirname(path)
					local msg
					if vim.fs.relpath("~", dir) then
						msg = "cwd: ~/" .. vim.fs.relpath("~", dir)
					else
						msg = "cwd: " .. dir
					end
					vim.notify(msg)
					vim.fn.chdir(dir)
				end
				local toggle_preview = function()
					local preview = MiniFiles.config.windows.preview
					local preview_next = not preview
					MiniFiles.config.windows.preview = preview_next
					MiniFiles.trim_right()
					MiniFiles.refresh({
						windows = { preview = preview_next },
					})
					if preview then
						local branch = MiniFiles.get_explorer_state().branch
						table.remove(branch)
						pcall(function()
							MiniFiles.set_branch(branch)
							return 0
						end)
					end
				end

				map("n", "<leader>e", function()
					minifiles_toggle(vim.api.nvim_buf_get_name(0), false)
					MiniFiles.reveal_cwd()
				end, { desc = "MiniFiles" })

				vim.api.nvim_create_autocmd("User", {
					pattern = "MiniFilesBufferCreate",
					callback = function(args)
						local b = args.data.buf_id
						map("n", "<leader>.", function() MiniFiles.open(nil) end, { buffer = b, desc = "go to cwd" })
						map("n", "J", "<DOWN>", { buffer = b })
						map("n", "K", "<UP>", { buffer = b })
						map("n", "<CR>", function() MiniFiles.go_in({ close_on_file = true }) end, { buffer = b })
						map("n", "q", function() MiniFiles.close() end, { buffer = b })
						map("n", "g.", set_cwd, { buffer = b, desc = "Set cwd" })
						map("n", "gy", yank_path, { buffer = b, desc = "Yank path" })
						map("n", "<C-space>", toggle_preview, { buffer = b, desc = "Toggle preview" })
					end,
				})

			end,
		},
		{
			"dmtrKovalenko/fff.nvim",
			version = "0.10.0",
			build = function() require("fff.download").download_or_build_binary() end,
			lazy = false,
			opts = {
				prompt = "❭ ",
				title = "fff",
				layout = { prompt_position = "top" },
				preview = { line_numbers = true },
				keymaps = { focus_preview = "/" },
				hl = {
					border = "Purple",
					normal = "Normal",
					matched = "Purple",
					title = "Red",
					prompt = "Question",
					cursor = "CursorLine",
					frecency = "Number",
					debug = "Comment",
					combo_header = "Number",
					scrollbar = "Comment",
					directory_path = "Comment",
					grep_match = "Red", -- Highlight for matched text in grep results
					grep_line_number = "LineNr", -- Highlight for :line:col location
					grep_regex_active = "DiagnosticInfo", -- Highlight for keybind + label when regex is on
					grep_plain_active = "Comment", -- Highlight for keybind + label when regex is off
					grep_fuzzy_active = "DiagnosticHint", -- Highlight for keybind + label when fuzzy is on
					suggestion_header = "WarningMsg", -- Highlight for the "No results found. Suggested..." banner
				},
				git = {
					status_text_color = true,
				},
				debug = { enabled = true, show_scores = false },
			},
			keys = {
				{ "ff", function() require("fff").find_files() end, desc = "FFFind files" },
				{ "<leader>fw", function() require("fff").live_grep() end, desc = "grep" },
				{ "<leader>fj", function() require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } }) end, desc = "fuzzy grep" },
				{ "<leader>f*", function() require("fff").live_grep_under_cursor() end, mode = { "n", "x" }, desc = "current word / selection" },
			},
		},
		{
			-- "FylerOrg/fyler.nvim", opts = { integrations = { icon = "mini_icons" }, extensions = { git = { enabled = true, inline = false }, trash = { enabled = true }, }, kind_presets = { split_left_most = { width = 40 }, floating = { win_opts = { winhighlight = "Normal:Normal,FloatBorder:Purple,FloatTitle:PurpleBold", }, }, }, ui = { hidden_items = { switches = {}, }, indent_guides = true, }, mappings = { n = { ["L"] = { action = "select" }, ["H"] = { action = "shrink", args = { parent = true } }, ["J"] = { action = function(_, _) vim.cmd("norm j") end }, ["K"] = { action = function(_, _) vim.cmd("norm k") end }, ["<CR>"] = { action = "select", args = { close = true } }, }, }, init = function() local fyler = require("fyler") map("n", "<leader>be", function() fyler.toggle({ kind = "floating" }) end, { desc = "Fyler" }) end, },
		},
		{
			-- "stevearc/oil.nvim", dependencies = { "nvim-mini/mini.icons" }, lazy = false,
			-- ---@module 'oil'
			-- ---@type oil.SetupOpts
			-- opts = { default_file_explorer = false, columns = { { "permissions", highlight = "Ignore" }, { "size", highlight = "Ignore" }, { "mtime", highlight = "Comment" }, "icon", }, delete_to_trash = true, watch_for_changes = true, keymaps = { ["?"] = { "actions.show_help", mode = "n" }, ["<CR>"] = "actions.select", ["s"] = { "actions.select", opts = { vertical = true } }, ["S"] = { "actions.select", opts = { horizontal = true } }, ["P"] = "actions.preview", ["<C-p>"] = "actions.preview_scroll_up", ["<C-n>"] = "actions.preview_scroll_down", ["<BS>"] = { "actions.parent", mode = "n" }, ["H"] = { "actions.parent", mode = "n" }, ["L"] = { "actions.select", mode = "n" }, ["J"] = { "j", mode = "n" }, ["K"] = { "k", mode = "n" }, ["~"] = { "actions.open_cwd", mode = "n" }, ["<leader>."] = { "actions.cd", mode = "n" }, ["gs"] = { "actions.change_sort", mode = "n" }, ["gx"] = "actions.open_external", ["gy"] = "actions.yank_entry", ["g."] = { "actions.toggle_hidden", mode = "n" }, ["g\\"] = { "actions.toggle_trash", mode = "n" }, ["q"] = { "actions.close", mode = "n" }, ["<ESC>"] = { "actions.close", mode = "n" }, ["ff"] = { function() require("snacks.picker").files({ hidden = true, ignored = true, cmd = "fd", dirs = { require("oil").get_current_dir() }, }) end, mode = "n", nowait = true, }, }, use_default_keymaps = false, view_options = { show_hidden = true, is_always_hidden = function(name, bufnr) return name:match("__.+__$") ~= nil end, }, win_options = { cursorcolumn = false, colorcolumn = "", statuscolumn = " %l ", numberwidth = 2, relativenumber = false, }, float = { max_height = 0.8, max_width = 0.8, border = "rounded", win_options = { winhighlight = "Normal:Normal,FloatBorder:Purple,FloatTitle:PurpleBold" }, title_pos = "center", }, }, init = function() local Oil = require("oil") map("n", "<Leader>bE", function() Oil.toggle_float(vim.fn.getcwd()) end, { desc = "Oil" }) end,
		},
		{
			-- "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", }, lazy = false,
			-- ---@module "neo-tree"
			-- ---@type neotree.Config?
			-- opts = { sources = { "filesystem" }, source_selector = { truncation_character = "…", show_scrolled_off_parent_node = true, sources = { { source = "filesystem" } }, }, filesystem = { filtered_items = { visible = true, never_show_by_pattern = { "**/__**__" }, }, follow_current_file = { enabled = true }, hijack_netrw_behavior = "open_current", }, window = { mappings = { ["<space>"] = "none", ["<"] = "none", [">"] = "none", ["<C-b>"] = "none", ["<C-f>"] = "none", ["f"] = "none", ["l"] = "open", ["h"] = "close_node", ["L"] = "focus_preview", ["<C-n>"] = { "scroll_preview", config = { direction = 10 } }, ["<C-p>"] = { "scroll_preview", config = { direction = -10 } }, ["C"] = "copy", ["c"] = {
			-- 				---@diagnostic disable-next-line: assign-type-mismatch
			-- 				function(state) local node = state.tree:get_node() local path = require("plenary.path"):new(node.path) local cwd = vim.fn.getcwd() local out = "./" .. path:make_relative(cwd) vim.notify("Yanked: " .. out, "info") vim.fn.setreg("+", out, "u") end, desc = "yank relpath", nowait = true, }, }, }, }, init = function() map("n", "<Leader>e", "<CMD>Neotree toggle left<CR>", { desc = "File explorer" }) map( "n", "<Leader>pz", function() require("neo-tree.command").execute({ dir = os.getenv("HOME") .. "/.local/share/chezmoi" }) end, { desc = "cd chezmoi" }) map("n", "<Leader>pc", function() require("neo-tree.command").execute({ dir = vim.fn.stdpath("config") }) end, { desc = "cd config" }) end,
		},
	},

	-- ===
	-- Utils
	{
		{
			"aserowy/tmux.nvim",
			event = "VeryLazy",
			opts = {
				copy_sync = {
					sync_registers_keymap_reg = false,
				},
			},
		},

		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			opts = {},
		},

		{
			"kylechui/nvim-surround",
			opts = {},
		},

		{
			"nvim-mini/mini.align",
			opts = {},
		},

		{
			"nvim-mini/mini.bracketed",
			opts = {
				comment = { suffix = "#" },
				file = { suffix = "e" },
				indent = { suffix = "h" },
			},
		},

		{
			"nvim-mini/mini.icons",
			opts = function()
				local style
				if vim.fn.environ()["TERM"] == "linux" then
					style = "ascii"
				else
					style = "glyph"
				end

				return {
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
				}
			end,
			init = function()
				package.preload["nvim-web-devicons"] = function()
					require("mini.icons").mock_nvim_web_devicons()
					return package.loaded["nvim-web-devicons"]
				end
			end,
		},
		{
			"folke/flash.nvim",
			event = "InsertEnter",
			---@type Flash.Config
			opts = {
				modes = {
					---@diagnostic disable-next-line: missing-fields
					char = {
						enabled = false,
						autohide = true,
					},
				},
				label = {
					rainbow = {
						enabled = true,
						shade = 6,
					},
				},
				prompt = {
					enabled = false,
				},
			},
			init = function()
				---@type Flash.Commands
				local flash = require("flash")
				map({ "n", "x", "o" }, "+", function() flash.jump() end, { desc = "Flash Jump" })
				map({ "n", "x", "o" }, "-", function() flash.treesitter() end, { desc = "Flash Treesitter" })
				map("o", "r", function() flash.remote() end, { desc = "Flash Remote" })
			end,
		},

		{
			"MagicDuck/grug-far.nvim",
			cmd = "GrugFar",
			opts = {},
		},

		{
			"brenoprata10/nvim-highlight-colors",
			opts = {},
		},

		{
			"nvimdev/hlsearch.nvim",
			opts = {},
		},

		{
			"fei6409/log-highlight.nvim",
			ft = "log",
			opts = {},
		},
	},

	-- ===
	-- UI
	{
		{
			"folke/which-key.nvim",
			dependencies = {
				"nvim-mini/mini.icons",
			},
			event = "VeryLazy",
			opts = {
				sort = { "order", "group", "alphanum", "mod", "case" },
				expand = 1,
				preset = "helix",
				show_help = false,
				spec = {
					{ "<BS>", mode = { "n" }, group = "Close" },
					{ "<Leader>e", mode = { "n" }, group = "Explorer" },
					{ "<Leader>f", mode = { "n", "x" }, group = "Find" },
					{ "<Leader>g", mode = { "n", "x" }, group = "Git" },
					{ "<Leader>l", mode = { "n", "x" }, group = "Language Tools" },
					{ "<Leader>b", mode = "n", group = "Buffers" },
					{ "<Leader>u", mode = "n", group = "UI" },
					{ "<Leader>d", mode = "n", group = "Debugger" },
					{ "<Leader>p", mode = "n", group = "Packages" },
					{ "<Leader>x", mode = "n", group = "Extras" },
					{ "<Leader>m", mode = "n", group = "Markdown" },
					{ ">>", mode = "n", desc = "indent line" },
					{ "<<", mode = "n", desc = "unindent line" },
				},
				icons = {
					separator = "",
					group = "",
					rules = {
						{ pattern = "buffer", icon = "", color = "green" },
						{ pattern = "explorer", icon = "󰙅", color = "red" },
						{ pattern = "undotree", icon = "󰕍", color = "red" },
						{ pattern = "history", icon = "", color = "yellow" },
						{ pattern = "language", icon = "󱌯", color = "purple" },
						{ pattern = "conflict", icon = "", color = "green" },
						{ pattern = "config", icon = "", color = "orange" },
						{ pattern = "packages", icon = "󰏗", color = "red" },
						{ pattern = "extras", icon = "󱁖", color = "yellow" },
						{ pattern = "home", icon = "", color = "purple" },
						{ pattern = "cd", icon = "", color = "cyan" },
						{ pattern = "math", icon = "󰒠", color = "purple" },
						{ pattern = "fold", icon = "", color = "gray" },
						{ pattern = "right", icon = "󱦰", color = "azure" },
						{ pattern = "left", icon = "󱦱", color = "azure" },
						{ pattern = "top", icon = "", color = "azure" },
						{ pattern = "bottom", icon = "", color = "azure" },
						{ pattern = "center", icon = "󰘢", color = "azure" },
						{ pattern = "list", icon = "󰉹", color = "blue" },
						{ pattern = "chatbot", icon = "󱚡", color = "gray" },
						{ pattern = "markdown", icon = "", color = "purple" },
						{ pattern = "debugger", icon = "", color = "red" },
						{ pattern = "trouble", icon = "", color = "red" },
						{ pattern = "overlook", icon = "", color = "blue" },
						{ pattern = "peek", icon = "", color = "green" },
						{ pattern = "noneckpain", icon = "", color = "blue" },
						{ pattern = "yazi", icon = "󰙅", color = "cyan" },
						{ pattern = "go", icon = "", color = "yellow" },
						{ pattern = "align", icon = "󱇃", color = "green" },
						{ pattern = "prev", icon = "󱦱", color = "purple" },
						{ pattern = "first", icon = "󰘀", color = "purple" },
						{ pattern = "last", icon = "󰘁", color = "purple" },
						{ pattern = "insert", icon = "", color = "green" },
						{ pattern = "selection", icon = "󰒉", color = "red" },
						{ pattern = "lowercase", icon = "󰀬", color = "azure" },
						{ pattern = "uppercase", icon = "󱀍", color = "azure" },
						{ pattern = "vim", icon = "", color = "azure" },
						{ pattern = "cycle", icon = "⭮", color = "azure" },
					},
				},
				win = {
					no_overlap = false,
				},
			},
		},
		{
			"folke/noice.nvim",
			dependencies = {
				"MunifTanjim/nui.nvim",
			},
			event = "VeryLazy",
			opts = {
				presets = {
					bottom_search = true,
					lsp_doc_border = true,
				},
				views = {
					split = {
						enter = false,
						size = "auto",
					},
					popup = {
						size = "auto",
					},
				},
				routes = {
					{
						filter = {
							event = "msg_show",
							any = {
								{ kind = "bufwrite" },
								{ kind = "undo" },
								{ find = "%d+ lines" },
								{ find = "%d+ more lines" },
								{ find = "%d+ fewer" },
								{ find = "is deprecated" },
								{ find = "Hunk %d+ of %d+" },
							},
						},
						view = "mini",
					},
					{
						filter = {
							event = "msg_show",
							kind = "lua_print",
						},
						view = "notify",
					},
					{
						filter = {
							event = "msg_show",
							min_height = 5,
							cmdline = true,
						},
						view = "popup",
					},
					{
						filter = {
							event = "notify",
							cond = function(message) return message.opts.title == "config sync" end,
						},
						view = "mini",
					},
				},
				lsp = {
					progress = { enabled = false },
					override = {
						["cmp.entry.get_documentation"] = false,
					},
				},
				cmdline = {
					enabled = true,
					view = "cmdline_popup",
				},
				popupmenu = {
					enabled = true,
				},
			},
			init = function()
				map({ "n", "i", "s" }, "<C-n>", function() require("noice.lsp").scroll(4) end, { desc = "Scroll hover down" })
				map({ "n", "i", "s" }, "<C-p>", function() require("noice.lsp").scroll(-4) end, { desc = "Scroll hover up" })
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			opts = function()
				local macro = require("lualine.component"):extend()
				function macro.update_status()
					local reg = vim.fn.reg_recording()
					if reg == "" then return "" end
					return "recording @" .. reg
				end

				local lsp_format = require("lualine.component"):extend()
				function lsp_format.update_status()
					local out = ""
					local bufnr = vim.api.nvim_get_current_buf()
					if #vim.lsp.get_clients({ bufnr = bufnr }) > 0 then out = out .. " " end

					local _, conform = pcall(require, "conform")
					if not conform then return "Conform not installed" end
					if #conform.list_formatters_for_buffer(bufnr) > 0 then out = out .. "󰉼" end

					return out
				end

				-- local formatters = function() local status, conform = pcall(require, "conform") if not status then return "Conform not installed" end local lsp_format = require("conform.lsp_format") local formatters = conform.list_formatters_for_buffer() if formatters and #formatters > 0 then local formatterNames = {} for _, formatter in ipairs(formatters) do table.insert(formatterNames, formatter) end return table.concat(formatterNames, " ") end local bufnr = vim.api.nvim_get_current_buf() local lsp_clients = lsp_format.get_format_clients({ bufnr = bufnr }) if not vim.tbl_isempty(lsp_clients) then return "󰷈 LSP Formatter" end return "" end

				-- my custom config
				-- return { options = { theme = "auto", component_separators = "", section_separators = { left = icons.lualine.rsep, right = icons.lualine.lsep }, globalstatus = true, disabled_filetypes = { { "snacks_dashboard" } }, }, sections = { lualine_a = { { "mode", separator = { left = icons.lualine.lsep }, right_padding = 2 } }, lualine_b = { "branch" }, lualine_c = { { "filetype", padding = { left = 1, right = 0 }, icon_only = true, }, { "filename", path = 1, symbols = { modified = icons.lualine.modified, readonly = icons.lualine.readonly, unnamed = icons.lualine.unnamed, newfile = icons.lualine.newfile, }, padding = 0, }, {"diagnostics"}, { macro, color = "lualine_c_diagnostics_error_insert", }, { "diff", symbols = { added = icons.git.added .. " ", modified = icons.git.modified .. " ", removed = icons.git.removed .. " ", }, source = function() local gitsigns = vim.b.gitsigns_status_dict if gitsigns then return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed, } end end, diff_color = { added = "GitSignsStagedAdd", modified = "GitSignsStagedChange", removed = "GitSignsStagedDelete"}, }, }, lualine_x = { { "lsp_status", formatters, }, }, lualine_y = { { "fileformat", padding = { left = 0, right = 0 } }, "location", }, lualine_z = { { "progress", }, }, }, tabline = { lualine_a = { { "buffers", mode = 4, hide_filename_extension = true, symbols = { alternate_file = icons.lualine.alternate .. " ", modified = " " .. icons.lualine.modified, }, filetype_names = { snacks_picker_list = icons.filetype.snacks_picker_list, ["dap-view-term"] = icons.debug.bug, }, use_mode_colors = true, cond = function() if vim.fn.expand("%") == "" then return false else return true end end, }, }, lualine_b = {}, lualine_c = {}, lualine_x = { { trouble.get, cond = trouble.has, }, }, lualine_y = { { "tabs", use_mode_colors = true, show_modified_status = false, }, }, lualine_z = {}, } }

				-- Evilline
				local conditions = {
					buffer_not_empty = function() return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 end,
					hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
					check_git_workspace = function()
						local filepath = vim.fn.expand("%:p:h")
						local gitdir = vim.fn.finddir(".git", filepath .. ";")
						return gitdir and #gitdir > 0 and #gitdir < #filepath
					end,
				}
				local colors = {
					bg = "NONE",
					fg = "#bbc2cf",
					yellow = "#ECBE7B",
					cyan = "#008080",
					darkblue = "#081633",
					green = "#98be65",
					orange = "#FF8800",
					violet = "#a9a1e1",
					magenta = "#c678dd",
					blue = "#51afef",
					red = "#ec5f67",
				}
				local config = {
					options = {
						globalstatus = true,
						component_separators = "",
						section_separators = "",
						disabled_filetypes = { "snacks_dashboard" },
					},
					sections = {
						lualine_a = {},
						lualine_b = {},
						lualine_y = {},
						lualine_z = {},
						lualine_c = {},
						lualine_x = {},
					},
					inactive_sections = {
						lualine_a = {},
						lualine_b = {},
						lualine_y = {},
						lualine_z = {},
						lualine_c = {},
						lualine_x = {},
					},
				}

				local function ins_left(component) table.insert(config.sections.lualine_c, component) end
				local function ins_right(component) table.insert(config.sections.lualine_x, component) end

				ins_left({
					-- mode component
					function() return vim.fn.mode() end,
					color = function()
						local mode_color = {
							n = colors.red,
							i = colors.green,
							v = colors.blue,
							V = colors.blue,
							[""] = colors.cyan,
							c = colors.magenta,
							no = colors.red,
							s = colors.orange,
							S = colors.orange,
							[""] = colors.orange,
							ic = colors.yellow,
							R = colors.violet,
							Rv = colors.violet,
							cv = colors.red,
							ce = colors.red,
							r = colors.cyan,
							rm = colors.cyan,
							["r?"] = colors.cyan,
							["!"] = colors.red,
							t = colors.green,
						}
						return { fg = colors.darkblue, bg = mode_color[vim.fn.mode()] }
					end,
					padding = 2,
				})
				ins_left({ "%n", color = { fg = colors.violet } })
				ins_left({
					"filesize",
					cond = conditions.buffer_not_empty and conditions.hide_in_width,
				})
				ins_left({
					"location",
					cond = conditions.buffer_not_empty,
				})
				ins_left({
					"progress",
					color = { fg = colors.fg, gui = "bold" },
					cond = conditions.buffer_not_empty,
				})
				ins_left({
					"diagnostics",
					sources = { "nvim_diagnostic" },
					symbols = { error = " ", warn = " ", info = " " },
					diagnostics_color = {
						error = { fg = colors.red },
						warn = { fg = colors.yellow },
						info = { fg = colors.cyan },
					},
				})
				ins_left({ macro, color = { fg = colors.red, gui = "bold" } })
				ins_left({ "%=" })
				ins_left({
					"filename",
					cond = conditions.buffer_not_empty,
					path = 1,
					color = { fg = colors.magenta, gui = "bold" },
				})
				ins_right({
					"lsp_status",
					icon = "",
					symbols = { done = "", separator = "" },
					show_name = false,
					padding = 0,
					color = { fg = colors.cyan },
				})
				ins_right({
					lsp_format,
					color = { fg = colors.cyan, gui = "bold" },
				})
				ins_right({
					"%Y",
					color = { fg = colors.green, gui = "bold" },
				})
				ins_right({
					"fileformat",
					fmt = string.upper,
					icons_enabled = true,
					color = { fg = colors.green, gui = "bold" },
				})
				ins_right({
					"branch",
					icon = "",
					color = { fg = colors.violet, gui = "bold" },
				})
				ins_right({
					"diff",
					symbols = { added = " ", modified = "󰝤 ", removed = " " },
					diff_color = {
						added = { fg = colors.green },
						modified = { fg = colors.orange },
						removed = { fg = colors.red },
					},
					cond = conditions.hide_in_width,
				})
				ins_right({
					function() return "▊" end,
					color = { fg = colors.blue },
					padding = { left = 1 },
				})
				return config
			end,
		},
		{
			"akinsho/bufferline.nvim",
			event = "VeryLazy",
			version = "*",
			opts = {
				options = {
					themable = true,
					right_mouse_command = function() require("snacks").bufdelete() end,
					diagnostics = "nvim_lsp",
					show_tab_indicators = true,
					offsets = {
						{
							filetype = "neo-tree",
							text = "",
							highlight = "BufferLineTab",
							separator = true,
						},
					},
					show_buffer_close_icons = false,
					tab_size = 10,
				},
			},
			init = function()
				map("n", "vv", "<CMD>BufferLinePick<CR>", { desc = "Pick buffer" })
				map("n", "<leader>bx", "<CMD>BufferLinePickClose<CR>", { desc = "Pick buffer to close" })
			end,
		},
	},

	-- ===
	-- Mason
	{
		{
			"mason-org/mason.nvim",
			version = "*",
			cmd = "Mason",
			build = ":MasonUpdate",
			opts = {},
			init = function() map("n", "<Leader>pm", "<CMD>Mason<CR>", { desc = "Mason" }) end,
		},
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			dependencies = {
				"mason-org/mason.nvim",
			},
			opts = function()
				local installs = {}
				if vim.fn.has("win32") == 1 then
					installs = {
						"marksman",
						"prettier",
						"fixjson",
					}
				else
					installs = {
						"ty",
						"bashls",
						"marksman",
						"docker-language-server",
						"stylua",
						"ruff",
						"emmylua_ls",
						"prettier",
						"fixjson",
						"tombi",
						"debugpy",
						"tree-sitter-cli",
					}
				end
				return {
					ensure_installed = installs,
				}
			end,
		},
		{
			"mason-org/mason-lspconfig.nvim",
			dependencies = {
				"mason-org/mason.nvim",
				{ "neovim/nvim-lspconfig", version = "*" },
			},
			opts = {
				automatic_enable = {
					exclude = { "stylua" },
				},
			},
		},
	},

	-- ===
	-- Sessions
	{
		"stevearc/resession.nvim",
		opts = {
			autosave = {
				enabled = true,
				interval = 60,
				notify = false,
			},
		},
		init = function()
			local resession = require("resession")
			local function get_session_name()
				local name = vim.fn.getcwd()
				local branch = vim.trim(vim.fn.system("git branch --show-current"))
				if vim.v.shell_error == 0 then
					return name .. branch
				else
					return name
				end
			end
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function() resession.save(get_session_name(), { dir = "dirsession", notify = false }) end,
			})
		end,
	},

	-- ===
	-- Snacks
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			terminal = {
				win = {
					wo = { statuscolumn = " ", winhighlight = "Normal:Normal,FloatBorder:Green" },
					position = "float",
					backdrop = 100,
					border = "rounded",
					height = 0.9,
				},
				auto_close = true,
			},
			explorer = { enabled = true, replace_netrw = false },
			dashboard = {
				preset = {
					header = require("stuff.ascii").cat,
					keys = {
						-- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{
							icon = "󰙅 ",
							key = "e",
							desc = "File Explorer",
							action = ":e .",
						},
						{
							icon = " ",
							key = "d",
							desc = "CodeDiff",
							action = ":CodeDiff",
						},
						{
							icon = " ",
							key = "s",
							desc = "Restore Session",
							action = function()
								local function get_session_name()
									local name = vim.fn.getcwd()
									local branch = vim.trim(vim.fn.system("git branch --show-current"))
									if vim.v.shell_error == 0 then
										return name .. branch
									else
										return name
									end
								end
								require("resession").load(get_session_name(), { dir = "dirsession", silence_errors = true })
							end,
						},
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 0, padding = 2 },
					{
						section = "recent_files",
						icon = " ",
						title = "Recent Files",
						indent = 2,
						padding = 2,
						limit = 10,
					},
					{ section = "startup" },
				},
			},
			image = { enabled = true, math = { enabled = false } },
			indent = { enabled = true, scope = { only_current = true } },
			input = { enabled = true },
			---@diagnostic disable-next-line: missing-fields
			lazygit = { theme = { selectedLineBgColor = { bg = "Visual" } } },
			picker = {
				layout = function()
					if vim.o.columns >= 140 then
						---@diagnostic disable-next-line: return-type-mismatch
						return { preset = "default" }
					else
						---@diagnostic disable-next-line: return-type-mismatch
						return {
							layout = {
								box = "vertical",
								backdrop = false,
								width = 0.8,
								min_width = 90,
								height = 0.8,
								min_height = 30,
								border = "rounded",
								title = "{title} {live} {flags}",
								title_pos = "center",
								{ win = "input", height = 1, border = "bottom" },
								{ win = "list", border = "bottom" },
								{
									win = "preview",
									title = "{preview}",
									height = 0.8,
									border = "top",
									wo = { wrap = true, statuscolumn = "%l ", relativenumber = false, foldcolumn = "0" },
								},
							},
						}
					end
				end,
				sources = {
					explorer = {
						exclude = { "__**__", ".ipynb_checkpoints" },
						follow_file = true,
						hidden = true,
						ignored = true,
						follow = true,
					},
					colorschemes = {
						layout = { preset = "dropdown" },
					},
				},
				win = {
					input = {
						keys = {
							["/"] = "focus_preview",
							["<C-p>"] = "preview_scroll_up",
							["<C-n>"] = "preview_scroll_down",
							["<a-i>"] = "inspect",
							["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "" },
							["<C-b>"] = false,
							["<C-f>"] = false,
							["<S-CR>"] = false,
							["<a-f>"] = false,
							["<a-h>"] = false,
							["<a-m>"] = false,
							["<c-j>"] = false,
							["<c-k>"] = false,
							["<C-Down>"] = false,
							["<C-Up>"] = false,
							["<a-d>"] = false,
							["<c-g>"] = false,
							["<c-t>"] = false,
							["<c-r><c-a>"] = false,
							["<c-r><c-f>"] = false,
							["<c-r><c-l>"] = false,
							["<c-r><c-p>"] = false,
							["<c-r><c-w>"] = false,
							["<C-c>"] = false,
							["<a-w>"] = false,
						},
					},
					list = {
						keys = {
							["/"] = "focus_preview",
							["<C-p>"] = "preview_scroll_up",
							["<C-n>"] = "preview_scroll_down",
							["<a-i>"] = "inspect",
							["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "" },
							["<C-b>"] = false,
							["<C-f>"] = false,
							["<S-CR>"] = false,
							["<a-f>"] = false,
							["<a-h>"] = false,
							["<a-m>"] = false,
							["<c-j>"] = false,
							["<c-k>"] = false,
							["<C-Down>"] = false,
							["<C-Up>"] = false,
							["<a-d>"] = false,
							["<c-g>"] = false,
							["<c-t>"] = false,
							["<c-r><c-a>"] = false,
							["<c-r><c-f>"] = false,
							["<c-r><c-l>"] = false,
							["<c-r><c-p>"] = false,
							["<c-r><c-w>"] = false,
							["<C-c>"] = false,
							["<a-w>"] = false,
						},
					},
					preview = {
						keys = {
							["/"] = "focus_list",
						},
					},
				},
			},
			notifier = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = false },
			scratch = {
				---@diagnostic disable-next-line: missing-fields
				win = {
					wo = {
						number = true,
						relativenumber = false,
						numberwidth = 2,
						statuscolumn = "%l %s",
						winhighlight = "Normal:Normal,FloatBorder:SnacksPickerBorder,FloatTitle:SnacksPickerTitle",
					},
					relative = "editor",
				},
			},
			statuscolumn = { enabled = true },
		},
		init = function()
			local Snacks = require("snacks")
			local group = vim.api.nvim_create_augroup("Snacks", { clear = true })

			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				group = group,
				callback = function()
					---@diagnostic disable-next-line: global-in-non-module
					_G.dd = function(...) Snacks.debug.inspect(...) end
					---@diagnostic disable-next-line: global-in-non-module
					_G.bt = function() Snacks.debug.backtrace() end
					vim.print = _G.dd
				end,
			})
			map("n", "<leader>c", function() Snacks.bufdelete() end, { desc = "Close buffer" })
			map("n", "<leader>bc", function() Snacks.bufdelete.other() end, { desc = "Close all other buffers" })
			map("n", "<Leader>fe", function() Snacks.explorer() end, { desc = "File explorer" })
			map({ "n", "t", "i" }, "<F7>", function() Snacks.terminal.toggle() end, { desc = "toggle terminal" })
			map("n", "<Leader>R", function() Snacks.rename.rename_file() end, { desc = "Rename file" })

			-- map("n", "ff", function() Snacks.picker.files() end, { desc = "files" })
			-- map("n", "<Leader>fw", function() Snacks.picker.grep({ cmd = "rg" }) end, { desc = "word" })
			-- map({ "n", "x" }, "<Leader>f*", function() Snacks.picker.grep_word() end, { desc = "grep current selection" })
			map("n", "<Leader>ff", function() Snacks.picker.files({ hidden = true, ignored = true, cmd = "fd" }) end, { desc = "all files" })
			map("n", "<Leader>fW", function() Snacks.picker.grep({ cmd = "rg", hidden = true, ignored = true }) end, { desc = "Word in all files" })

			map("n", "<Leader>f:", function() Snacks.picker.command_history() end, { desc = "Command history" })
			map("n", "<Leader>f<space>", function() Snacks.picker.resume() end, { desc = "Resume last search" })
			map("n", "<Leader>f=", function() Snacks.picker.spelling() end, { desc = "Spelling Suggestions" })
			map("n", "<Leader>fA", function() Snacks.picker.autocmds() end, { desc = "autocmds" })
			map("n", "<Leader>fC", function() Snacks.picker.commands() end, { desc = "Commands" })
			map("n", "<Leader>fJ", function() Snacks.picker.jumps() end, { desc = "jumps" })
			map("n", "<Leader>fL", function() Snacks.picker.loclist() end, { desc = "location list" })
			map("n", "<Leader>fM", function() Snacks.picker.man() end, { desc = "Man pages" })
			map("n", "<Leader>fR", function() Snacks.picker.registers() end, { desc = "registers" })
			map("n", "<Leader>fb", function() Snacks.picker.buffers() end, { desc = "buffers" })
			map("n", "<Leader>fd", function() Snacks.picker.diagnostics_buffer() end, { desc = "diagnostics" })
			map("n", "<Leader>fk", function() Snacks.picker.keymaps() end, { desc = "keymaps" })
			map("n", "<Leader>fH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
			map("n", "<Leader>fm", function() Snacks.picker.marks() end, { desc = "marks" })
			map("n", "<Leader>fp", function() Snacks.picker.projects() end, { desc = "projects" })
			map("n", "<Leader>fq", function() Snacks.picker.qflist() end, { desc = "quickfix list" })
			map("n", "<Leader>fr", function() Snacks.picker.recent() end, { desc = "recent" })
			map("n", "<Leader>fu", function() Snacks.picker.undo() end, { desc = "undo" })
			map("n", "<Leader>fz", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "local config" })
			map("n", "<Leader>fS", function() Snacks.picker.scratch() end, { desc = "local config" })

			map("n", "<Leader>bs", function() Snacks.scratch() end, { desc = "scratch buffer" })
			map("n", "<Leader>bS", function() Snacks.scratch.select() end, { desc = "search scratch buffers" })
			map("n", "<Leader>uc", function() Snacks.picker.colorschemes() end, { desc = "search colorschemes" })
			map("n", "<Leader>uz", function() Snacks.zen.zoom() end, { desc = "zoom pane" })
			---@diagnostic disable-next-line: missing-parameter
			map("n", "<Leader>uZ", function() Snacks.zen() end, { desc = "Zen mode" })
			map("n", "<Leader>un", function() Snacks.notifier.hide() end, { desc = "dismiss all notifications" })
			map("n", "<Leader>gl", function() Snacks.picker.git_log_file() end, { desc = "Log file" })
			map("n", "<Leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })

			map("n", "<Leader>ll", "", { desc = "LSP" })
			map("n", "<Leader>llr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "references" })
			map("n", "<Leader>lls", function() Snacks.picker.lsp_symbols() end, { desc = "LSP symbols" })
			map("n", "<Leader>llw", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP workspace Symbols" })
			map("n", "<Leader>lli", function() Snacks.picker.lsp_implementations() end, { desc = "Go to Implementation" })
			map("n", "<Leader>llt", function() Snacks.picker.lsp_type_definitions() end, { desc = "Go to type definition" })
			map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Go to definition" })
			map("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Go to Declaration" })

			local toggles = require("stuff.toggles")
			toggles.autosave():map("<Leader>ba")
			toggles.formatting():map("<Leader>bF")
			toggles.completion():map("<Leader>bC")
			toggles.virtual_text():map("<Leader>uv")
			toggles.virtual_lines():map("<Leader>uV")
			toggles.math_virt():map("<Leader>um")
			Snacks.toggle.option("spell", { name = "spellcheck" }):map("<leader>us")
			Snacks.toggle.option("wrap", { name = "wrap" }):map("<leader>uw")
			Snacks.toggle.option("relativenumber", { name = "relative number" }):map("<leader>ul")
			Snacks.toggle.option("background", { off = "light", on = "dark", name = "dark background" }):map("<leader>ub")
			Snacks.toggle.option("scrollbind"):map("<leader>uS")
			Snacks.toggle.diagnostics():map("<leader>ud")
			Snacks.toggle.line_number():map("<leader>uL")
			Snacks.toggle.treesitter():map("<leader>uT")
			Snacks.toggle.inlay_hints():map("<leader>uI")
			Snacks.toggle.indent():map("<leader>ug")
			Snacks.toggle.dim():map("<leader>uD")

			map("n", "<Leader>fa", function()
				if vim.fn.has("win32") == 1 then
					vim.notify("Do not mess with config from Windows", vim.log.levels.ERROR)
				else
					Snacks.picker.files({
						hidden = true,
						ignored = true,
						follow = true,
						dirs = { os.getenv("HOME") .. "/.local/share/chezmoi" },
					})
				end
			end, { desc = "config" })

			map("n", "<Leader>fh", function()
				local cols = vim.o.columns
				local lines = vim.o.lines
				if (cols / lines > 3) and (cols > 180) then
					return Snacks.picker.help({ confirm = "vsplit" })
				else
					return Snacks.picker.help()
				end
			end, { desc = "help pages" })

			map(
				"n",
				"<Leader>ui",
				function()
					require("snacks.picker").icons({
						custom_sources = { unicode = vim.fn.stdpath("config") .. "/unicode_chars.json" },
					})
				end,
				{ desc = "icons" }
			)
			-- map("i", "<C-l>", function() local pos = vim.fn.getcursorcharpos() require("snacks.picker").icons({ custom_sources = { unicode = vim.fn.stdpath("config") .. "/unicode_chars.json" }, }) vim.fn.setcursorcharpos(pos) end, { desc = "insert icon" })
			map("n", "<Leader>N", function()
				require("snacks").picker.notifications({
					confirm = { "yank", "close" },
					focus = "list",
					layout = {
						---@diagnostic disable-next-line: missing-fields
						layout = {
							box = "vertical",
							backdrop = false,
							width = 0.8,
							min_width = 90,
							height = 0.8,
							min_height = 30,
							border = "rounded",
							title = "{title} {live} {flags}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
							{
								win = "preview",
								title = "{preview}",
								height = 0.8,
								border = "top",
								wo = { wrap = true, statuscolumn = "%l ", relativenumber = false, foldcolumn = "0" },
							},
						},
					},
					win = {
						input = { keys = { ["<C-Space>"] = { "cycle_win", mode = { "i", "n" } } } },
						list = { keys = { ["<C-Space>"] = { "cycle_win", mode = { "i", "n" } } } },
						preview = { keys = { ["<C-Space>"] = { "cycle_win", mode = { "i", "n" } } } },
					},
				})
			end, { desc = "Notification history" })
		end,
	},

	-- ===
	-- sniprun — code runner
	{
		"michaelb/sniprun",
		branch = "master",
		build = "bash install.sh 1",
		enabled = vim.fn.has("linux") == 1,
		ft = "python",
		opts = {
			selected_interpreters = { "Python3_fifo" },
			repl_enable = { "Python3_fifo" },
			display = { "Terminal" },
			display_options = { terminal_position = "horizontal" },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("SnipRun", { clear = true }),
				pattern = { "python" },
				callback = function()
					map("n", "<Leader>r", "", { desc = "Run Code", buffer = true })
					map("n", "<CR>", "<CMD>SnipRun<CR>", { desc = "Run line", buffer = true })
					map("v", "<CR>", ":SnipRun<CR>", { desc = "Run selection", buffer = true })
					map("n", "<Leader>rc", "<CMD>SnipClose<CR>", { desc = "Close REPL", buffer = true })
					map("n", "<Leader>rl", "<CMD>SnipRun<CR>", { desc = "Run line", buffer = true })
					map("n", "<Leader>rf", "<CMD>%SnipRun<CR>", { desc = "Run file", buffer = true })
					map("n", "<Leader>rR", "<CMD>SnipReset<CR>", { desc = "Reset REPL", buffer = true })
					map("n", "<Leader>rb", function()
						vim.api.nvim_feedkeys("Vggok", "n", false)
						vim.cmd("SnipRun")
						vim.cmd("normal! ")
					end, { desc = "Run above", buffer = true })
					-- map("n", "<Leader>r<Space>", function()
					-- 	vim.api.nvim_feedkeys("vaj", "n", false)
					-- 	vim.cmd("SnipRun")
					-- 	vim.cmd("normal! ")
					-- end, { desc = "Run cell", buffer = true })

					-- TODO: API viewer
					-- local sa = require("sniprun.api")
					-- local function listener(d)
					-- 	local config = { midline_pct = 0.4, topline_pct = 0.2, height_pct = 0.6, outwin = { width_pct = 0.55 } }
					-- 	vim.b.sniprun_buf = vim.api.nvim_get_current_buf()
					-- 	vim.b.sniprun_win = vim.api.nvim_get_current_win()
					-- 	local win_config = vim.api.nvim_win_get_config(vim.b.sniprun_win)
					-- 	if win_config.relative ~= "" then
					-- 		local cols, rows = vim.o.columns, vim.o.lines
					-- 		local height = math.ceil(rows * config.height_pct)
					-- 		vim.api.nvim_win_set_config(
					-- 			vim.b.sniprun_win,
					-- 			{ relative = "editor", anchor = "NE", col = cols * config.midline_pct, row = rows * config.topline_pct, height = height }
					-- 		)
					-- 		if not vim.b.sniprun_outbuf then vim.b.sniprun_outbuf = vim.api.nvim_create_buf(false, true) end
					-- 		vim.schedule(function()
					-- 			if vim.b.sniprun_outwin == nil then
					-- 				vim.b.sniprun_outwin = vim.api.nvim_open_win(
					-- 					vim.b.sniprun_outbuf,
					-- 					false,
					-- 					{
					-- 						relative = "editor",
					-- 						col = cols * config.midline_pct,
					-- 						row = rows * config.topline_pct,
					-- 						width = math.max(win_config.width, math.ceil(cols * config.outwin.width_pct)),
					-- 						height = height,
					-- 						style = "minimal",
					-- 					}
					-- 				)
					-- 				vim.api.nvim_create_autocmd(
					-- 					"BufHidden",
					-- 					{
					-- 						group = vim.api.nvim_create_augroup("SnipRun_APIWinClose", { clear = true }),
					-- 						pattern = tostring(vim.b.sniprun_buf),
					-- 						callback = function() vim.api.nvim_win_close(vim.b.sniprun_outwin, true) end,
					-- 					}
					-- 				)
					-- 			end
					-- 		end)
					-- 		vim.api.nvim_set_option_value("winhl", vim.wo[vim.b.sniprun_win].winhighlight, { win = vim.b.sniprun_outwin })
					-- 		print("in floating cond", vim.b.sniprun_outbuf, vim.b.sniprun_outwin)
					-- 		if vim.b.sniprun_outbuf == 0 or vim.b.sniprun_outwin == 0 then
					-- 			vim.notify("SnipRun output buffer could not be created", vim.log.levels.ERROR)
					-- 			return
					-- 		end
					-- 		print("hellooo")
					-- 		if d.status == "ok" then
					-- 			print("nice: ", d.message)
					-- 		elseif d.status == "error" then
					-- 			print("no: ", d.message)
					-- 		else
					-- 			print("Unknown status: ", d.status)
					-- 		end
					-- 	end
					-- end
					-- if #sa.listeners == 0 then sa.register_listener(listener) end

				end,
			})

		end,
	},

	-- ===
	-- Treesitter
	{
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
			opts = function()
				local parsers = {
					"bash",
					"c",
					"css",
					"diff",
					"dockerfile",
					"git_config",
					"gitignore",
					"json",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"python",
					"query",
					"readline",
					"ssh_config",
					"toml",
					"typescript",
					"vim",
					"vimdoc",
					"yaml",
				}

				return {
					ensure_installed = parsers,
					ignore_install = { "csv" },
					auto_install = true,
					fold = { enable = true },
					highlight = { enable = true },
					indent = { enable = true },
				}
			end,
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
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			lazy = true,
			opts = {
				multiwindow = true,
				max_lines = 5,
				multiline_threshold = 1,
				mode = "topline",
			},
		},
	},

	-- ===
	-- LSP/Diagnostics
	{
		{
			-- "WilliamHsieh/overlook.nvim", event = "LspAttach", opts = {}, init = function() map("n", "go", require("overlook.api").peek_definition, { desc = "Peek definition" }) end,
		},
		{
			-- "folke/trouble.nvim", cmd = "Trouble", opts = { focus = true, modes = { diagnostics = { mode = "diagnostics", preview = { type = "split", relative = "win", position = "left", size = 20, }, filter = function(items) local severity = vim.diagnostic.severity.HINT for _, item in ipairs(items) do severity = math.min(severity, item.severity) end return vim.tbl_filter(function(item) return item.severity == severity end, items) end, }, }, win = { colorcolumn = false, }, }, init = function() map("n", "<Leader>t", "", { desc = "Trouble" }) map("n", "<Leader>td", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "diagnostics" }) map("n", "<Leader>tD", "<CMD>Trouble diagnostics toggle<CR>", { desc = "workspace diagnostics" }) map("n", "<Leader>ts", "<CMD>Trouble symbols toggle focus=true pinned=true win.relative=editor<CR>", { desc = "symbols" }) map( "n", "<Leader>tS", "<CMD>Trouble lsp_document_symbols toggle pinned=true win.relative=editor win.position=right<CR>", { desc = "all symbols" }) map("n", "<Leader>tl", "<CMD>Trouble loclist<CR>", { desc = "loclist" }) map("n", "<Leader>tq", "<CMD>Trouble qflist<CR>", { desc = "quickfix list" }) map("n", "<Leader>tt", "<CMD>TodoTrouble<CR>", { desc = "Todo List" }) end,
		},
		{
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			event = "VeryLazy",
			opts = {
				keywords = {
					FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
					TODO = { icon = " ", color = "info" },
					HACK = { icon = "󰣈 ", color = "test" },
					WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
					PERF = { icon = " ", color = "test", alt = { "PERFORMANCE", "OPTIMIZE" } },
					NOTE = { icon = "󰎛 ", color = "hint", alt = { "INFO", "IDEA" } },
					TEST = { icon = "󰟶 ", color = "default", alt = { "TESTING", "PASSED", "FAILED" } },
				},
				search = {
					args = {
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--glob=!conf/*.yaml",
					},
				},
				colors = {
					default = { "DiagnosticOk", "Identifier", "#7C3AED" },
					test = { "Linkage", "Identifier", "#FF00FF" },
				},
			},
			init = function() map("n", "<Leader>T", "<CMD>TodoTrouble<CR>", { desc = "Todo List" }) end,
		},
	},

	-- ===
	-- Notebooks
	{
		{
			-- "SUSTech-data/neopyter",
			-- dependencies = {
			-- 	"AbaoFromCUG/websocket.nvim", -- for mode='direct'
			-- },
			-- ---@type neopyter.Option
			-- opts = {
			-- 	mode = "direct",
			-- 	remote_address = "127.0.0.1:9001",
			-- 	file_pattern = { "*.ju.*" },
			-- 	on_attach = function(buf)
			-- 		map("n", "<C-Enter>", "<cmd>Neopyter execute notebook:run-cell<cr>", { desc = "run selected", buffer = buf })
			-- 		map("n", "<space>X", "<cmd>Neopyter execute notebook:run-all-above<cr>", { desc = "run all above cell", buffer = buf })
			-- 		map("n", "<space>nt", "<cmd>Neopyter execute kernelmenu:restart<cr>", { desc = "restart kernel", buffer = buf })
			-- 		map(
			-- 			"n",
			-- 			"<S-Enter>",
			-- 			"<cmd>Neopyter execute notebook:run-cell-and-select-next<cr>",
			-- 			{ desc = "run selected and select next", buffer = buf }
			-- 		)
			-- 		map(
			-- 			"n",
			-- 			"<M-Enter>",
			-- 			"<cmd>Neopyter execute notebook:run-cell-and-insert-below<cr>",
			-- 			{ desc = "run selected and insert below", buffer = buf }
			-- 		)
			-- 		map("n", "<F5>", "<cmd>Neopyter execute notebook:restart-run-all<cr>", { desc = "restart kernel and run all", buffer = buf })
			-- 	end,
			-- },
		},
	},

	-- ===
	-- AI
	{
		{
			-- 	"yetone/avante.nvim",
			-- 	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" or "make",
			-- 	event = "VeryLazy",
			-- 	version = false,
			-- 	---@module 'avante'
			-- 	---@type avante.Config
			-- 	opts = {
			-- 		instructions_file = "avante.md",
			-- 		provider = "openrouter",
			-- 		providers = {
			-- 			openrouter = {
			-- 				__inherited_from = "openai",
			-- 				endpoint = "https://openrouter.ai/api/v1",
			-- 				api_key_name = "OPENROUTER_API_KEY",
			-- 				model = "z-ai/glm-4.5-air:free",
			-- 			},
			-- 		},
			-- 		selector = {
			-- 			provider = "snacks",
			-- 			provider_opts = {},
			-- 		},
			-- 		input = {
			-- 			provider = "snacks",
			-- 			provider_opts = {
			-- 				title = "Avante Input",
			-- 				icon = " ",
			-- 			},
			-- 		},
			-- 	},
			-- 	dependencies = {
			-- 		"nvim-lua/plenary.nvim",
			-- 		"MunifTanjim/nui.nvim",
			-- 		"folke/snacks.nvim",
			-- 		{
			-- 			"MeanderingProgrammer/render-markdown.nvim",
			-- 			opts = { file_types = { "markdown", "Avante" } },
			-- 			ft = { "markdown", "Avante" },
			-- 		},
			-- 	},
		},
		{
			-- 	"olimorris/codecompanion.nvim",
			-- 	version = "17.33.0",
			-- 	dependencies = {
			-- 		"nvim-lua/plenary.nvim",
			-- 	},
			-- 	cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
			-- 	opts = {
			-- 		display = {
			-- 			chat = {
			-- 				intro_message = "Chatbot time 󰭹 󰓠 󰚩   . Press ? for options",
			-- 				separator = "---",
			-- 				start_in_insert_mode = false,
			-- 				icons = { buffer_watch = " " },
			-- 				window = { layout = "horizontal", height = 0.45 },
			-- 			},
			-- 			diff = {
			-- 				provider_opts = {
			-- 					split = { opts = { "filler", "closeoff", "algorithm:minimal", "followwrap", "linematch:120" } },
			-- 				},
			-- 			},
			-- 			action_palette = { provider = "default" },
			-- 		},
			-- 		strategies = {
			-- 			chat = {
			-- 				adapter = "gptoss120b_ol_df2",
			-- 				variables = {
			-- 					["buffer"] = { opts = { default_params = "watch" } },
			-- 				},
			-- 				tools = {
			-- 					opts = {
			-- 						auto_submit_errors = true,
			-- 						auto_submit_success = true,
			-- 						default_tools = { "web_search", "file_search", "grep_search", "read_file" },
			-- 					},
			-- 				},
			-- 			},
			-- 			inline = { adapter = "qwen3vl_ol_df2" },
			-- 			cmd = { adapter = "gptoss120b_ol_df2" },
			-- 		},
			-- 		adapters = {
			-- 			http = {
			-- 				opts = { show_defaults = false },
			-- 				gptoss120b_ol_df2 = function()
			-- 					return require("codecompanion.adapters").extend("ollama", {
			-- 						name = "gptoss120b_ol_df2",
			-- 						env = { url = "http://100.106.205.69:11434" },
			-- 						headers = { ["Content-Type"] = "application/json" },
			-- 						schema = {
			-- 							model = { default = "gpt-oss:120b" },
			-- 							keep_alive = { default = "15m" },
			-- 						},
			-- 					})
			-- 				end,
			-- 				qwen3vl_ol_df2 = function()
			-- 					return require("codecompanion.adapters").extend("ollama", {
			-- 						name = "qwen3vl_ol_df2",
			-- 						env = { url = "http://100.106.205.69:11434" },
			-- 						headers = { ["Content-Type"] = "application/json" },
			-- 						schema = {
			-- 							model = { default = "qwen3-vl:32b" },
			-- 							keep_alive = { default = "15m" },
			-- 						},
			-- 					})
			-- 				end,
			-- 				gptoss120b_lc_df2 = function()
			-- 					return require("codecompanion.adapters").extend("openai", {
			-- 						name = "llamacpp",
			-- 						url = "http://100.106.205.69:8000/v1/chat/completions",
			-- 						schema = {
			-- 							model = { default = "/models/gpt-oss-120b/gpt-oss-120b-mxfp4-00001-of-00003.gguf" },
			-- 						},
			-- 					})
			-- 				end,
			-- 				gptoss20b_lc_bs = function()
			-- 					return require("codecompanion.adapters").extend("openai", {
			-- 						name = "llamacpp",
			-- 						url = "http://100.92.126.115:8000/v1/chat/completions",
			-- 						schema = {
			-- 							model = { default = "/models/gpt-oss-20b/gpt-oss-20b-mxfp4.gguf" },
			-- 						},
			-- 					})
			-- 				end,
			-- 				qwen3_ol_office = function()
			-- 					return require("codecompanion.adapters").extend("ollama", {
			-- 						name = "ollama_office",
			-- 						env = { url = "http://100.113.130.46:11434" },
			-- 						headers = { ["Content-Type"] = "application/json" },
			-- 						schema = {
			-- 							model = { default = "qwen3:latest" },
			-- 							num_ctx = { default = 16384 },
			-- 							keep_alive = { default = "60m" },
			-- 						},
			-- 					})
			-- 				end,
			-- 				tavily = function()
			-- 					return require("codecompanion.adapters").extend("tavily", {
			-- 						env = { api_key = "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" },
			-- 					})
			-- 				end,
			-- 			},
			-- 			acp = { opts = { show_defaults = false } },
			-- 		},
			-- 	},
			-- 	init = function()
			-- 		local map = require("stuff.functions").map
			-- 		map({ "n", "x" }, "<Leader>a", "", { desc = "Chatbot" })
			-- 		map({ "n", "x" }, "<Leader>aa", "<CMD>CodeCompanionActions<CR>", { desc = "actions" })
			-- 		map({ "n", "x" }, "<Leader>at", "<CMD>CodeCompanionChat Toggle<CR>", { desc = "toggle chat window" })
			-- 		map({ "n", "x" }, "<Leader>ai", ":CodeCompanion ", { desc = "inline assist" })
			-- 		map("x", "<Leader>ac", "<CMD>CodeCompanionChat Add<CR>", { desc = "add visual selection to chat" })
			-- 	end,
		},
	},
}
