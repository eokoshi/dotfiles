return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		terminal = {
			win = {
				wo = { statuscolumn = " " },
				position = "float",
				backdrop = 100,
				border = "rounded",
				height = 0.9,
			},
			auto_close = true,
		},
		explorer = { enabled = false },
		dashboard = {
			preset = {
				header = require("stuff.ascii").cat,
				keys = {
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = "󰙅 ",
						key = "e",
						desc = "File Explorer",
						action = function()
							require("neo-tree.command").execute({ position = "float" })
						end,
					},
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{
						icon = " ",
						key = "w",
						desc = "Find Word",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{ icon = " ", key = "r", desc = "Recents", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = function()
							local dir
							if vim.fn.has("win32") == 1 then
								vim.notify(
									"Do not mess with config from Windows, edit in chezmoi dir on linux",
									vim.log.levels.ERROR
								)
							else
								dir = os.getenv("HOME") .. "/.local/share/chezmoi"
								vim.cmd("cd " .. dir)
								require("neo-tree.command").execute({ position = "float" })
							end
						end,
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
				{ section = "keys", gap = 1, padding = 2 },
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
		indent = { enabled = true },
		input = { enabled = true },
		lazygit = {
			---@diagnostic disable-next-line: missing-fields
			theme = {
				selectedLineBgColor = { bg = "Visual" },
			},
		},
		picker = {
			layout = function()
				if vim.o.columns >= 140 then
					return { preset = "default" }
				else
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
					exclude = { ".gitattributes", "__**__", ".ipynb_checkpoints" },
					follow_file = true,
					hidden = true,
					ignored = true,
					follow = true,
				},
				colorschemes = {
					layout = {
						preset = "dropdown",
					},
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
		local map = require("stuff.functions").map

		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			group = group,
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd -- Override print to use snacks for `:=` command
			end,
		})

		-- stylua: ignore start
		map("n", "<Leader>c", function() Snacks.bufdelete() end, { desc = "Close buffer" })
		map("n", "<Leader>H", function() Snacks.dashboard() end, { desc = "Home" })
		map("n", "<Leader>R", function() Snacks.rename.rename_file() end, { desc = "Rename file" })
		map("n", "<Leader>:", function() Snacks.picker.command_history() end, { desc = "Command history" })
		map({ "n", "t", "i" }, "<F7>", function() Snacks.terminal.toggle() end, { desc = "toggle terminal" })
		map("n", "<Leader>fz", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "local config" })
		map("n", "<Leader>fb", function() Snacks.picker.buffers() end, { desc = "buffers" })
		map("n", "<Leader>fC", function() Snacks.picker.commands() end, { desc = "Commands" })
		map("n", "<Leader>fd", function() Snacks.picker.diagnostics() end, { desc = "diagnostics" })
		map("n", "<Leader>fD", function() Snacks.picker.diagnostics_buffer() end, { desc = "buffer Diagnostics" })
		map("n", "<Leader>fH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
		map("n", "<Leader>ff", function() Snacks.picker.files() end, { desc = "files" })
		map("n", "<Leader>fF", function() Snacks.picker.files({ hidden = true, ignored = true, cmd = "fd" }) end, { desc = "all files" })
		map("n", "<Leader>fk", function() Snacks.picker.keymaps() end, { desc = "keymaps" })
		map("n", "<Leader>fj", function() Snacks.picker.jumps() end, { desc = "jumps" })
		map("n", "<Leader>fl", function() Snacks.picker.loclist() end, { desc = "location list" })
		map("n", "<Leader>fm", function() Snacks.picker.marks() end, { desc = "marks" })
		map("n", "<Leader>fM", function() Snacks.picker.man() end, { desc = "Man pages" })
		map("n", "<Leader>fp", function() Snacks.picker.projects() end, { desc = "projects" })
		map("n", "<Leader>fq", function() Snacks.picker.qflist() end, { desc = "quickfix list" })
		map("n", "<Leader>fr", function() Snacks.picker.recent() end, { desc = "recent" })
		map("n", "<Leader>fs", function() Snacks.scratch.select() end, { desc = "find scratch buffers" })
		map("n", "<Leader>fu", function() Snacks.picker.undo() end, { desc = "undo" })
		map("n", "<Leader>fw", function() Snacks.picker.grep({ cmd = "rg" }) end, { desc = "word" })
		map("n", "<Leader>fW", function() Snacks.picker.grep({ cmd = "rg", hidden = true, ignored = true }) end, { desc = "Word in all files" })
		map("n", "<Leader>f<space>", function() Snacks.picker.resume() end, { desc = "Resume last search" })
		map({ "n", "x" }, "<Leader>f*", function() Snacks.picker.grep_word() end, { desc = "grep current selection" })
		map("n", "<Leader>bc", function() Snacks.bufdelete.other() end, { desc = "Close all other bufs" })
		map("n", "<Leader>bs", function() Snacks.scratch() end, { desc = "scratch buffer" })
		map("n", "<Leader>uc", function() Snacks.picker.colorschemes() end, { desc = "search colorschemes" })
		map("n", "<Leader>uz", function() Snacks.zen.zoom() end, { desc = "zoom pane" })
		map("n", "<Leader>uZ", function() Snacks.zen() end, { desc = "Zen mode" })
		map("n", "<Leader>un", function() Snacks.notifier.hide() end, { desc = "dismiss all notifications" })
		map("n", "<Leader>gb", function() Snacks.picker.git_branches() end, { desc = "Branches" })
		map("n", "<Leader>gl", function() Snacks.picker.git_log_file() end, { desc = "Log file" })
		map("n", "<Leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
		map("n", "<Leader>lR", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "references" })
		map("n", "<Leader>ls", function() Snacks.picker.lsp_symbols() end, { desc = "LSP symbols" })
		map("n", "<Leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP workspace Symbols" })
		map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Go to definition" })
		map("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Go to Declaration" })
		map("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Go to Implementation" })
		map("n", "gp", function() Snacks.picker.lsp_type_definitions() end, { desc = "Go to ty[p]e definition" })

		local toggles = require("stuff.toggles")
		toggles.autosave():map("<Leader>ba")
		toggles.virtual_text():map("<Leader>uv")
		toggles.virtual_lines():map("<Leader>uV")
		toggles.math_virt():map("<Leader>um")
		Snacks.toggle.option("spell", { name = "spellcheck" }):map("<leader>us")
		Snacks.toggle.option("wrap", { name = "wrap" }):map("<leader>uw")
		Snacks.toggle.option("relativenumber", { name = "relative number" }):map("<leader>uL")
		Snacks.toggle.option("hlsearch", { name = "hlsearch" }):map("<Leader>uh")
		Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uC")
		Snacks.toggle.option("background", { off = "light", on = "dark", name = "dark background" }):map("<leader>ub")
		Snacks.toggle.diagnostics():map("<leader>ud")
		Snacks.toggle.line_number():map("<leader>ul")
		Snacks.toggle.treesitter():map("<leader>uT")
		Snacks.toggle.inlay_hints():map("<leader>uI")
		Snacks.toggle.indent():map("<leader>ug")
		Snacks.toggle.dim():map("<leader>uD")

		-- stylua: ignore end

		map("n", "<Leader>fa", function()
			if vim.fn.has("win32") == 1 then
				vim.notify("Do not mess with config from Windows, edit in chezmoi dir on linux", vim.log.levels.ERROR)
			else
				Snacks.picker.files({
					hidden = true,
					ignored = true,
					follow = true,
					dirs = {
						os.getenv("HOME") .. "/.local/share/chezmoi",
					},
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

		map("n", "<Leader>xN", function()
			Snacks.win({
				file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
				width = 90,
				height = 0.6,
				wo = {
					spell = false,
					wrap = false,
					signcolumn = "yes",
					statuscolumn = " ",
					conceallevel = 3,
				},
			})
		end, { desc = "Neovim News" })

		map("n", "<Leader>ui", function()
			---@diagnostic disable-next-line: missing-parameter
			local snacks_data = require("snacks.picker.source.icons").icons({})

			local file = vim.fn.stdpath("config") .. "/unicode_chars.json"
			local fd = assert(io.open(file, "r"))
			local data = fd:read("*a")
			fd:close()
			data = vim.json.decode(data)

			local result = {} ---@type snacks.picker.Icon[]
			for desc, info in pairs(data) do
				table.insert(result, {
					category = info.code,
					icon = info.char,
					name = desc,
					source = "unicode",
				})
			end
			for _, icon in ipairs(result) do
				icon.text = Snacks.picker.util.text(icon, { "source", "category", "name" })
				icon.data = icon.icon
			end
			---@diagnostic disable-next-line: param-type-mismatch
			for _, v in ipairs(snacks_data) do
				table.insert(result, v)
			end
			Snacks.picker.pick({
				items = result,
				layout = { preset = "vscode" },
				confirm = "put",
				format = "icon",
			})
		end, { desc = "icons" })

		map("n", "<Leader>N", function()
			require("snacks").picker.notifications({
				confirm = { "yank", "close" },
				focus = "list",
				layout = {
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
					input = {
						keys = {
							["<C-Space>"] = { "cycle_win", mode = { "i", "n" } },
						},
					},
					list = {
						keys = {
							["<C-Space>"] = { "cycle_win", mode = { "i", "n" } },
						},
					},
					preview = {
						keys = {
							["<C-Space>"] = { "cycle_win", mode = { "i", "n" } },
						},
					},
				},
			})
		end, { desc = "Notification history" })
	end,
}
