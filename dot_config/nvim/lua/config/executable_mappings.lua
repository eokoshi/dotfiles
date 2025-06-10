local Snacks = require("snacks")
local functions = require("stuff.functions")
local toggles = require("stuff.toggles")

local function map(mode, lhs, rhs, opts)
	-- set default value if not specify
	if opts.noremap == "" then
		opts.noremap = true
	end
	if opts.silent == "" then
		opts.silent = true
	end

	vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- stylua: ignore start

-- Basic operations
map("n", "<Leader>c", function() Snacks.bufdelete() end, { desc = "Close buffer" })
map("n", "<Leader>e", function() Snacks.explorer({ exclude = {".gitattributes", "__**__", }, follow_file = true, hidden = true, ignored = true, follow = true, }) end, { desc = "File explorer" })
map("n", "<Leader>n", function() functions.notifications_picker() end, { desc = "Notification history" })
map("n", "<Leader>h", function() Snacks.dashboard() end, { desc = "Home" })
map("n", "<Leader>q", "<CMD>q<CR>", { desc = "Quit window" })
map("n", "<Leader>Q", "<CMD>qa<CR>", { desc = "Quit nvim" })
map("n", "<Leader>R", function() Snacks.rename.rename_file() end, { desc = "Rename file" })
map("n", "<Leader>U", "<CMD>UndotreeToggle<CR>", { desc = "Open Undotree" })
map("n", "<Leader>w", "<CMD>w<CR>", { desc = "Save buffer" })
map("n", "<Leader>.", "<CMD>cd %:h<CR>", { desc = "cd here" })
map("n", "<Leader>:", function() Snacks.picker.command_history() end, { desc = "Command history" })
map("n", "<Leader><space>", function() Snacks.picker.smart() end, { desc = "Smart search" })

-- System clipboard
map({ "n", "v" }, "<A-S-V>", "<C-v>", { desc = "Visual block mode" })
map({ "n" }, "<C-c>", '"+yy', { desc = "Copy line to system clipboard" })
map({ "v" }, "<C-c>", '"+y', { desc = "Copy selection to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste system clipboard" })
map({ "i", "c" }, "<C-v>", '<ESC>"+pa', { desc = "Paste system clipboard" })
map("n", "<C-a>", "<CMD>%y+<CR><CR>", { desc = "Copy whole file to clipboard" })

-- Movement
map("n", "<C-u>", "<C-u>zz", { desc = "Jump up half page" })
map("n", "<C-d>", "<C-d>zz", { desc = "Jump down half page" })
map("n", "<C-o>", "<C-o>zz", { desc = "Jump to previous location" })
map("n", "<C-i>", "<C-i>zz", { desc = "Jump to next location" })
map("n", "n", "nzzzv", { desc = "Jump to next search result" })
map("n", "N", "Nzzzv", { desc = "Jump to previous search result" })
map("n", "<C-h>", "<C-w>h", { desc = "Move to window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to window above" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to window below" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to window right" })
map({ "i", "c" }, "<C-l>", "<C-o>a", { desc = "Move one char right" })
map({ "i", "c" }, "<C-h>", "<C-o>h", { desc = "Move one char left" })
map("i", "<S-Tab>", "<C-d>", { desc = "Unindent 1 level" })
map("n", "J", "mzJ`z", { desc = "Shift J without moving cursor", noremap = false })
map({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
map({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
map("n", "<C-Up>", function() require("smart-splits").resize_up() end, { desc = "Resize split up" })
map("n", "<C-Down>", function() require("smart-splits").resize_down() end, { desc = "Resize split down" })
map("n", "<C-Left>", function() require("smart-splits").resize_left() end, { desc = "Resize split left" })
map("n", "<C-Right>", function() require("smart-splits").resize_right() end, { desc = "Resize split right" })

-- Find
map("n", "<Leader>f", "", { desc = "Find" })
map("n", "<Leader>fa", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "config files" })
map("n", "<Leader>fb", function() Snacks.picker.buffers() end, { desc = "buffers" })
map("n", "<Leader>fB", function() Snacks.picker.grep_buffers() end, { desc = "grep in open Buffers" })
map({ "n", "x" }, "<Leader>fc", function() Snacks.picker.grep_word() end, { desc = "grep current selection" })
map("n", "<Leader>fC", function() Snacks.picker.commands() end, { desc = "Commands" })
map("n", "<Leader>fd", function() Snacks.picker.diagnostics() end, { desc = "diagnostics" })
map("n", "<Leader>fD", function() Snacks.picker.diagnostics_buffer() end, { desc = "buffer Diagnostics" })
map("n", "<Leader>fh", function() Snacks.picker.help() end, { desc = "help pages" })
map("n", "<Leader>fH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
map("n", "<Leader>ff", function() Snacks.picker.files() end, { desc = "files" })
map("n", "<Leader>fF", function() Snacks.picker.files({ hidden = true, ignored = true, cmd = "fd" }) end, { desc = "all files" })
map("n", "<Leader>fg", function() Snacks.picker.git_files() end, { desc = "git files" })
map("n", "<Leader>fk", function() Snacks.picker.keymaps() end, { desc = "keymaps" })
map("n", "<Leader>fj", function() Snacks.picker.jumps() end, { desc = "jumps" })
map("n", "<Leader>fl", function() Snacks.picker.loclist() end, { desc = "location list" })
map("n", "<Leader>fm", function() Snacks.picker.marks() end, { desc = "marks" })
map("n", "<Leader>fM", function() Snacks.picker.man() end, { desc = "Man pages" })
map("n", "<Leader>fp", function() Snacks.picker.projects() end, { desc = "projects" })
map("n", "<Leader>fq", function() Snacks.picker.qflist() end, { desc = "quickfix list" })
map("n", "<Leader>fr", function() Snacks.picker.recent() end, { desc = "recent" })
map("n", "<Leader>fu", function() Snacks.picker.undo() end, { desc = "undo" })
map("n", "<Leader>fw", function() Snacks.picker.grep({ cmd = "rg" }) end, { desc = "word" })
map("n", "<Leader>fW", function() Snacks.picker.grep({ cmd = "rg", hidden = true, ignored = true }) end, { desc = "Word in all files" })
map("n", "<Leader>f<CR>", function() Snacks.picker.resume() end, { desc = "Resume last search" })

-- Buffer
map("n", "<Leader>b", "", { desc = "Buffers" })
map("n", "<Leader>bD", function() functions.DOS_to_Unix() end, { desc = "DOS to Unix" })
toggles.autosave():map("<Leader>ba")

-- UI
map("n", "<Leader>u", "", { desc = "UI" })
map("n", "<Leader>ui", function() Snacks.picker.icons() end, { desc = "icons" })
map("n", "<Leader>uc", function() Snacks.picker.colorschemes() end, { desc = "search colorschemes" })
map("n", "<Leader>uz", function() Snacks.zen.zoom() end, { desc = "zoom pane" })
map("n", "<Leader>uZ", function() Snacks.zen() end, { desc = "Zen mode" })
map("n", "<Leader>un", function() Snacks.notifier.hide() end, { desc = "dismiss all notifications" })
map("n", "<Leader>uN", function() require("noice").disable() require("noice").enable() end, { desc = "reload Noice" })
toggles.virtual_text():map("<Leader>uv")
toggles.virtual_lines():map("<Leader>uV")
Snacks.toggle.option("spell", { name = "spellcheck" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "relative number" }):map("<leader>uL")
Snacks.toggle.option("hlsearch", { name = "hlsearch" }):map("<Leader>uh")
Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map( "<leader>uC")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "dark background" }):map("<leader>ub")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.inlay_hints():map("<leader>uI")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.dim():map("<leader>uD")

-- Git
map("n", "<Leader>g", "", { desc = "Git" })
map("n", "<Leader>gb", function() Snacks.picker.git_branches() end, { desc = "git branches" })
map({ "n", "v" }, "<Leader>gB", function() Snacks.gitbrowse() end, { desc = "git browse" })
map("n", "<Leader>gd", function() Snacks.picker.git_diff() end, { desc = "git diff (hunks)" })
map("n", "<Leader>gf", function() Snacks.picker.git_log_file() end, { desc = "git log file" })
map("n", "<Leader>gg", function() Snacks.lazygit() end, { desc = "lazygit" })
map("n", "<Leader>gl", function() Snacks.picker.git_log() end, { desc = "git log" })
map("n", "<Leader>gL", function() Snacks.picker.git_log_line() end, { desc = "git log line" })
map("n", "<Leader>gs", function() Snacks.picker.git_status() end, { desc = "git status" })
map("n", "<Leader>gS", function() Snacks.picker.git_stash() end, { desc = "git Stash" })

-- Language Tools
map("n", "<Leader>l", "", { desc = "Language Tools" })
map({ "n", "x" }, "<Leader>la", function() vim.lsp.buf.code_action() end, { desc = "LSP code actions" })
map("n", "<Leader>ld", function() vim.diagnostic.open_float() end, { desc = "hover diagnostics" })
map("n", "<Leader>lf", function() vim.lsp.buf.format() end, { desc = "format buffer" })
map("n", "<Leader>lh", function() vim.lsp.buf.signature_help() end, { desc = "signature help" })
map("n", "<Leader>ll", function() vim.lsp.codelens.run() end, { desc = "codelens run" })
map("n", "<Leader>lL", function() vim.lsp.codelens.refresh() end, { desc = "codelens refresh" })
map("n", "<Leader>li", "<CMD>LspInfo<CR>", { desc = "LSP info" })
map("n", "<Leader>lI", "<CMD>NullLsInfo<CR>", { desc = "Null-ls info" })
map("n", "<Leader>lr", function() vim.lsp.buf.rename() end, { desc = "rename symbol" })
map("n", "<Leader>lR", function() vim.lsp.buf.references() end, { desc = "search References" })
map("n", "<Leader>ls", function() Snacks.picker.lsp_symbols() end, { desc = "LSP symbols" })
map("n", "<Leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP workspace Symbols" })
map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto definition" })
map("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
map("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "references" })
map("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto t[y]pe definition" })
map("n", "gco", "o<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment below" })
map("n", "gcO", "O<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment above" })

-- Debugging
map("n", "<Leader>d", "", { desc = "Debugger" })
map("n", "<F5>", function() require("dap").continue() end, { desc = "Debugger: Start" })
map("n", "<F17>", function() require("dap").terminate() end, { desc = "Debugger: Stop" } ) -- Shift+F5
map("n", "<F29>", function() require("dap").restart_frame() end, { desc = "Debugger: Restart" }) -- Control+F5
map("n", "<F6>", function() require("dap").pause() end, { desc = "Debugger: Pause" })
map("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "Debugger: Toggle Breakpoint" })
map("n", "<F10>", function() require("dap").step_over() end, { desc = "Debugger: Step Over" })
map("n", "<F11>", function() require("dap").step_into() end, { desc = "Debugger: Step Into" })
map("n", "<F23>", function() require("dap").step_out() end, { desc = "Debugger: Step Out" }) -- Shift+F11
map("n", "<Leader>db", function() require("dap").toggle_breakpoint() end, {desc = "Toggle Breakpoint (F9)" })
map("n", "<Leader>dB", function() require("dap").clear_breakpoints() end, {desc = "Clear Breakpoints" })
map("n", "<Leader>dc", function() require("dap").continue() end, {desc = "Start/Continue (F5)" })
map("v", "<Leader>dE", function() require("dapui").eval() end, {desc = "Evaluate Input" })
map("n", "<Leader>dh", function() require("dap.ui.widgets").hover() end, {desc = "Debugger Hover" })
map("n", "<Leader>di", function() require("dap").step_into() end, {desc = "Step Into (F11)" })
map("n", "<Leader>dj", "<CMD>e $PWD/.vscode/launch.json", {desc = "Open workspace DAP config" })
map("n", "<Leader>do", function() require("dap").step_over() end, {desc = "Step Over (F10)" })
map("n", "<Leader>dO", function() require("dap").step_out() end, {desc = "Step Out (S-F11)" })
map("n", "<Leader>dp", function() require("dap").pause() end, {desc = "Pause (F6)" })
map("n", "<Leader>dq", function() require("dap").close() end, {desc = "Close Session" })
map("n", "<Leader>dQ", function() require("dap").terminate() end, {desc = "Terminate Session (S-F5)" })
map("n", "<Leader>dr", function() require("dap").restart_frame() end, {desc = "Restart (C-F5)" })
map("n", "<Leader>dR", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" })
map("n", "<Leader>ds", function() require("dap").run_to_cursor() end, {desc = "Run To Cursor" })
-- map("n", "<Leader>du", function() require("dapui").toggle() end, {desc = "Toggle Debugger UI" })
map("n", "<Leader>du", function() require("dap-view").toggle(true) end, {desc = "Toggle Debugger UI" })
map("n", "<F21>", function() vim.ui.input({ prompt = "Condition: " }, function(condition) if condition then require("dap").set_breakpoint(condition) end end) end, { desc = "Debugger: Conditional Breakpoint" }) -- Shift+F9
map("n", "<Leader>dC", function() vim.ui.input({ prompt = "Condition: " }, function(condition) if condition then require("dap").set_breakpoint(condition) end end) end, {desc = "Conditional Breakpoint (S-F9)" })
map("n", "<Leader>dE", function() vim.ui.input({ prompt = "Expression: " }, function(expr) if expr then require("dapui").eval(expr, { enter = true }) end end) end, {desc = "Evaluate Input"})

-- Terminal
map("n", "<Leader>t", "", { desc = "Terminal" })
map("n", "<Leader>tv", function() Snacks.terminal.get("/bin/bash", { win = {wo = {statuscolumn = " "}, position = "bottom", border = "hpad", height = 12}, auto_close=true}) end, { desc = "bottom terminal" })
map("n", "<Leader>th", function() Snacks.terminal.get("/bin/bash", { win = {wo = {statuscolumn = " "}, position = "right"}, auto_close=true}) end, { desc = "right terminal" })
map("n", "<Leader>tf", function() Snacks.terminal.get("/bin/bash", { win = {wo = {statuscolumn = " "}, position = "float", border = "rounded", backdrop = 100}, auto_close = true }) end, { desc = "floating terminal" })
map("n", "<Leader>tt", function() Snacks.terminal.toggle("/bin/bash", { win = {wo = {statuscolumn = " "}, position = "bottom", border = "hpad", height = 12}, auto_close=true}) end, { desc = "toggle terminal" })
map({ "n", "t", "i" }, "<F7>", function() Snacks.terminal.toggle("/bin/bash", { win = {wo = {statuscolumn = " "}, position = "bottom", border = "hpad", height = 12}, auto_close=true}) end, { desc = "toggle terminal" })

-- Package/Plugin Management
map("n", "<Leader>p", "", { desc = "Packages" })
map("n", "<Leader>pi", "<CMD>Lazy<CR>", { desc = "Lazy" })
map("n", "<Leader>pm", "<CMD>Mason<CR>", { desc = "Mason" })
map("n", "<Leader>pc", function() vim.fn.chdir(vim.fn.stdpath("config")) Snacks.explorer.open() end, { desc = "cd config" })
map("n", "<Leader>pa", function() vim.ui.input({ prompt = "Edit plugin spec" }, function(input)
		local file = vim.fn.stdpath("config") .. "/lua/plugins/" .. input .. ".lua"
		vim.notify("Editing " .. file)
		vim.cmd("e " .. file)
	end) end, { desc = "add plugin" })


-- Blink completion
vim.keymap.del("i", "<Tab>")

-- Diff keymaps
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		if vim.wo[0].diff then
			map({ "n", "v" }, "<Leader>dfo", "<CMD>diffget<CR>", { desc = "Get the text from the other buffer to this one" })
			map({ "n", "v" }, "<Leader>dfp", "<CMD>diffput<CR>", { desc = "Put the text from this buffer to the other" })
		end
	end,
})

-- Python keymaps
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*.py",
	callback = function()
		map("n", "<Leader>fi", "/import<CR>", { desc = "Jump to imports" })
	end,
})

-- Markdown keymaps
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*.md",
	callback = function()
		map("n", "<Leader>m", "", { desc = "Markdown" })
		map("n", "<Leader>mm", "<CMD>lua require('nabla').popup({border = 'solid'})<CR>", { desc = "Show math popup" })
		toggles.math_virt():map("<Leader>um")
	end,
})

-- Lua keymaps
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*.lua",
	callback = function()
		map("n", "<Leader>lx", function() Snacks.scratch() end, { desc = "scratch buffer" })
		map("n", "<Leader>lX", function() Snacks.scratch.select() end, { desc = "select scratch buffer" })
	end,
})

-- Extras/Fun stuff
map("n", "<Leader>x", "", { desc = "Extras" })
map("n", "<Leader>xa", function() require("ascii").preview() end, { desc = "Ascii art picker" })
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
