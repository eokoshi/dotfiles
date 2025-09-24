local Snacks = require("snacks")
local functions = require("stuff.functions")
local toggles = require("stuff.toggles")
local map = functions.map

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- stylua: ignore start

-- Basic operations
map("n", "<Leader>c", function() Snacks.bufdelete() end, { desc = "Close buffer" })
map("n", "<Leader>e", "<CMD>Neotree toggle left<CR>", { desc = "File explorer" })
map("n", "<Leader>n", "<CMD>NoNeckPain<CR>", { desc = "NoNeckPain" })
map("n", "<Leader>N", function() functions.notifications_picker() end, { desc = "Notification history" })
map("n", "<Leader>H", function() Snacks.dashboard() end, { desc = "Home" })
map("n", "<Leader>q", "<CMD>q<CR>", { desc = "Quit window" })
map("n", "<Leader>Q", "<CMD>qa<CR>", { desc = "Quit nvim" })
map("n", "<Leader>R", function() Snacks.rename.rename_file() end, { desc = "Rename file" })
map("n", "<Leader>U", "<CMD>UndotreeToggle<CR>", { desc = "Open Undotree" })
map("n", "<Leader>w", "<CMD>w<CR>", { desc = "Save buffer" })
map("n", "<Leader>.", "<CMD>cd %:h<CR>", { desc = "cd here" })
map("n", "<Leader>:", function() Snacks.picker.command_history() end, { desc = "Command history" })
map("n", "<Leader><space>", function() Snacks.picker.smart() end, { desc = "Smart search" })
map({ "n", "v" }, "c", "\"ac", { desc = "Do not yank text on change" })
map({ "n", "t", "i" }, "<F7>", function() Snacks.terminal.toggle("/bin/bash", { win = {wo = {statuscolumn = " "}, position = "float", backdrop=100, border = "rounded", height = 0.9}, auto_close=true}) end, { desc = "toggle terminal" })

-- System clipboard
map({ "n", "v" }, "<M-v>", "<C-v>", { desc = "Visual block mode" })
map({ "n" }, "<C-c>", '"+yy', { desc = "Copy line to system clipboard" })
map({ "v" }, "<C-c>", '"+y', { desc = "Copy selection to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste system clipboard" })
map({ "i", "c" }, "<C-v>", '<ESC>"+pa', { desc = "Paste system clipboard" })

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
map({"n", "i", "s"}, "<C-n>", function() require("noice.lsp").scroll(4) end, { desc = "Scroll hover down" })
map({"n", "i", "s"}, "<C-p>", function() require("noice.lsp").scroll(-4) end, { desc = "Scroll hover up" })
---@diagnostic disable-next-line: param-type-mismatch
map('n', ']c', function() if vim.wo.diff then vim.cmd.normal({']c', bang = true}) else require("gitsigns").nav_hunk('next') end end, { desc = "Next hunk"})
---@diagnostic disable-next-line: param-type-mismatch
map('n', '[c', function() if vim.wo.diff then vim.cmd.normal({'[c', bang = true}) else require("gitsigns").nav_hunk('prev') end end, { desc = "Prev hunk"})
map("n", "<BS>", "<C-^>", {desc="Switch to prev file"})

-- Find
map("n", "<Leader>f", "", { desc = "Find" })
map("n", "<Leader>fa", function() functions.pick_chezmoi() end, { desc = "config files (chezmoi)" })
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
map("n", "<Leader>fo", function() require("oil").toggle_float() end, { desc = "Oil explorer" })
map("n", "<Leader>fp", function() Snacks.picker.projects() end, { desc = "projects" })
map("n", "<Leader>fq", function() Snacks.picker.qflist() end, { desc = "quickfix list" })
map("n", "<Leader>fr", function() Snacks.picker.recent() end, { desc = "recent" })
map("n", "<Leader>fs", function() Snacks.scratch.select() end, { desc = "find scratch buffers" })
map("n", "<Leader>fu", function() Snacks.picker.undo() end, { desc = "undo" })
map("n", "<Leader>fw", function() Snacks.picker.grep({ cmd = "rg" }) end, { desc = "word" })
map("n", "<Leader>fW", function() Snacks.picker.grep({ cmd = "rg", hidden = true, ignored = true }) end, { desc = "Word in all files" })
map("n", "<Leader>fz", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "local config files" })
map("n", "<Leader>f<CR>", function() Snacks.picker.resume() end, { desc = "Resume last search" })

-- Buffers
map("n", "<Leader>b", "", { desc = "Buffers" })
map("n", "<Leader>bA", "<CMD>%y+<CR><CR>", { desc = "Copy whole buffer to clipboard" })
map("n", "<Leader>bD", function() functions.DOS_to_Unix() end, { desc = "DOS to Unix" })
map("n", "<Leader>bc", function() Snacks.bufdelete.other() end, { desc = "Close all other bufs" })
map("n", "<Leader>bf", function() vim.lsp.buf.format() end, { desc = "format buffer" })
map("n", "<Leader>bs", function() Snacks.scratch() end, { desc = "scratch buffer" })
map("n", "<Leader>bt", "<CMD>TodoTrouble<CR>", {desc = "Todo List"})
toggles.autosave():map("<Leader>ba")

-- UI
map("n", "<Leader>u", "", { desc = "UI" })
map("n", "<Leader>ui", function() functions.pick_icons() end, { desc = "icons" })
map("n", "<Leader>uc", function() Snacks.picker.colorschemes() end, { desc = "search colorschemes" })
map("n", "<Leader>uz", function() Snacks.zen.zoom() end, { desc = "zoom pane" })
map("n", "<Leader>uZ", function() Snacks.zen() end, { desc = "Zen mode" })
map("n", "<Leader>un", function() Snacks.notifier.hide() end, { desc = "dismiss all notifications" })
map("n", "<Leader>uN", function() require("noice").disable() require("noice").enable() end, { desc = "reload Noice" })
toggles.virtual_text():map("<Leader>uv")
toggles.virtual_lines():map("<Leader>uV")
toggles.math_virt():map("<Leader>um")
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
local gitsigns = require("gitsigns")
map("n", "<Leader>g", "", { desc = "Git" })
map("n", "<Leader>gb", function() Snacks.picker.git_branches() end, { desc = "git branches" })
map({ "n", "v" }, "<Leader>gB", function() Snacks.git.blame_line() end, { desc = "git blame line" })
map("n", "<Leader>gd", "<CMD>DiffviewOpen<CR>", { desc = "DiffView Open" })
map("n", "<Leader>gc", "<CMD>DiffviewClose<CR>", { desc = "DiffView Close" })
map("n", "<Leader>gf", function() Snacks.picker.git_log_file() end, { desc = "git log file" })
map("n", "<Leader>gg", function() Snacks.lazygit() end, { desc = "lazygit" })
map("n", "<Leader>gs", gitsigns.stage_hunk, { desc = "stage hunk" })
map("n", "<Leader>gr", gitsigns.reset_hunk, { desc = "reset hunk" })
map('v', '<leader>gs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, {desc = "stage hunk"})
map('v', '<leader>gr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, {desc = "reset hunk"})
map("n", "<Leader>gS", gitsigns.stage_buffer, { desc = "stage buffer" })
map("n", "<Leader>gR", gitsigns.reset_buffer, { desc = "reset buffer" })
map({'o', 'x'}, 'ih', gitsigns.select_hunk, { desc = "inside hunk"})
map({'o', 'x'}, 'ah', gitsigns.select_hunk, { desc = "around hunk"})

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
map("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Go to Implementation" })
map("n", "gp", function() Snacks.picker.lsp_type_definitions() end, { desc = "Go to ty[p]e definition" })
map("n", "gco", "o<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment below" })
map("n", "gcO", "O<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment above" })

-- overlook.nvim
map("n", "<Leader>o", "", {desc = "Overlook"})
map("n", "<leader>od", require("overlook.api").peek_definition, { desc = "Peek definition" })
map("n", "<leader>op", require("overlook.api").peek_cursor, { desc = "Peek cursor" })
map("n", "<leader>ou", require("overlook.api").restore_popup, { desc = "Restore last popup" })
map("n", "<leader>oU", require("overlook.api").restore_all_popups, { desc = "Restore all popups" })
map("n", "<leader>oc", require("overlook.api").close_all, { desc = "Close all popups" })
map("n", "<leader>os", require("overlook.api").open_in_split, { desc = "Open popup in split" })
map("n", "<leader>ov", require("overlook.api").open_in_vsplit, { desc = "Open popup in vsplit" })
map("n", "<leader>ot", require("overlook.api").open_in_tab, { desc = "Open popup in tab" })
map("n", "<leader>oo", require("overlook.api").open_in_original_window, { desc = "Open popup in current window" })

-- Trouble
map("n", "<Leader>t", "", {desc = "Trouble"})
map("n", "<Leader>td", "<CMD>Trouble diagnostics toggle focus=true filter.buf=0<CR>", {desc = "diagnostics list"})
map("n", "<Leader>tD", "<CMD>Trouble diagnostics toggle<CR>", {desc = "workspace diagnostics list"})
map("n", "<Leader>ts", "<CMD>Trouble symbols toggle pinned=true win.relative=editor win.position=right<CR>", {desc = "symbols"})
map("n", "<Leader>tt", "<CMD>TodoTrouble<CR>", {desc = "Todo List"})

-- Run code
map("n", "<Leader>r", "", {desc = "Run Code"})
map("n", "<Leader>rc", "<CMD>SnipClose<CR>", {desc = "Close REPL"})
map("n", "<Leader>rl", "<CMD>SnipRun<CR>", {desc = "Run line"})
map("n", "<Leader>rf", "<CMD>%SnipRun<CR>", {desc = "Run file"})
map("n", "<Leader>rr", "vip:SnipRun<CR><ESC>", {desc = "Run scope"})
map("n", "<Leader>rR", "<CMD>SnipReset<CR>", {desc = "Reset REPL"})
map("v", "<CR>", ":SnipRun<CR>", {desc = "Run selection"})


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
-- map("v", "<Leader>dE", function() require("dapui").eval() end, {desc = "Evaluate Input" })
map("n", "<Leader>dh", function() require("dap.ui.widgets").hover() end, {desc = "Debugger Hover" })
map("n", "<Leader>di", function() require("dap").step_into() end, {desc = "Step Into (F11)" })
map("n", "<Leader>dj", "<CMD>e $PWD/.vscode/launch.json<CR><CMD>w ++p<CR>", {desc = "Open workspace DAP config" })
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


-- Package/Plugin Management
map("n", "<Leader>p", "", { desc = "Packages" })
map("n", "<Leader>pi", "<CMD>Lazy<CR>", { desc = "Lazy" })
map("n", "<Leader>pm", "<CMD>Mason<CR>", { desc = "Mason" })
map("n", "<Leader>pc", function() require("neo-tree.command").execute({ dir=os.getenv("HOME").."/.local/share/chezmoi" }) end, { desc = "cd config" })
map("n", "<Leader>pa", function() vim.ui.input({ prompt = "Edit plugin spec" }, function(input)
	if input ~= nil then
		local file = vim.fn.stdpath("config") .. "/lua/plugins/" .. input .. ".lua"
		vim.notify("Editing " .. file, "info")
		vim.cmd("e " .. file)
	end
	end) end, { desc = "add plugin" })


-- LLM chatbot
map({"n", "v"}, "<Leader>a", "", { desc = "Chatbot" })
map({"n", "v"}, "<Leader>aa", "<CMD>CodeCompanionActions<CR>", { desc = "actions" })
map({ "n", "v" }, "<Leader>at", "<CMD>CodeCompanionChat Toggle<CR>", { desc = "toggle chat window" })
map({ "n", "v" }, "<Leader>ai", function() vim.ui.input({ prompt = "Inline Assistant"}, function(input) if input ~= nil then vim.cmd("CodeCompanion " .. input) end end) end, { desc = "inline assist" })
map("v", "ga", "<CMD>CodeCompanionChat Add<CR>", { desc = "add visual selection to chat" })
vim.cmd([[cab cc CodeCompanion]])

-- Blink completion
vim.keymap.del("i", "<Tab>")

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
