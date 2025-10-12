local functions = require("stuff.functions")
local map = functions.map

-- stylua: ignore start
-- Basic operations
map("n", "<Leader>q", "<CMD>q<CR>", { desc = "Quit window" })
map("n", "<Leader>Q", "<CMD>qa<CR>", { desc = "Quit nvim" })
map("n", "<Leader>w", "<CMD>w<CR>", { desc = "Save buffer" })
map("n", "<Leader>.", "<CMD>cd %:h<CR>", { desc = "cd here" })

map("n", "<Leader><space>", "<ESC>", { desc = "" })
map({ "n", "v" }, "c", "\"ac", { desc = "Do not yank text on change" })

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
map("n", "<BS>", "<C-^>", { desc = "Switch to prev file" })

-- Find


-- Buffers
map("n", "<Leader>bA", "<CMD>%y+<CR><CR>", { desc = "Copy whole buffer to clipboard" })
map("n", "<Leader>bD", function() functions.DOS_to_Unix() end, { desc = "DOS to Unix" })
map("n", "<Leader>bf", function() vim.lsp.buf.format() end, { desc = "format buffer" })


-- Language Tools
map({ "n", "x" }, "<Leader>la", function() vim.lsp.buf.code_action() end, { desc = "LSP code actions" })
map("n", "<Leader>ld", function() vim.diagnostic.open_float() end, { desc = "hover diagnostics" })
map("n", "<Leader>lf", function() vim.lsp.buf.format() end, { desc = "format buffer" })
map("n", "<Leader>lh", function() vim.lsp.buf.signature_help() end, { desc = "signature help" })
map("n", "<Leader>ll", function() vim.lsp.codelens.run() end, { desc = "codelens run" })
map("n", "<Leader>lL", function() vim.lsp.codelens.refresh() end, { desc = "codelens refresh" })
map("n", "<Leader>li", "<CMD>LspInfo<CR>", { desc = "LSP info" })
map("n", "<Leader>lI", "<CMD>NullLsInfo<CR>", { desc = "Null-ls info" })
map("n", "<Leader>lr", function() vim.lsp.buf.rename() end, { desc = "rename symbol" })
map("n", "gco", "o<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment below" })
map("n", "gcO", "O<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment above" })


-- Debugging
map("n", "<F5>", function() require("dap").continue() end, { desc = "Debugger: Start" })
map("n", "<F17>", function() require("dap").terminate() end, { desc = "Debugger: Stop" })        -- Shift+F5
map("n", "<F29>", function() require("dap").restart_frame() end, { desc = "Debugger: Restart" }) -- Control+F5
map("n", "<F6>", function() require("dap").pause() end, { desc = "Debugger: Pause" })
map("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "Debugger: Toggle Breakpoint" })
map("n", "<F10>", function() require("dap").step_over() end, { desc = "Debugger: Step Over" })
map("n", "<F11>", function() require("dap").step_into() end, { desc = "Debugger: Step Into" })
map("n", "<F23>", function() require("dap").step_out() end, { desc = "Debugger: Step Out" }) -- Shift+F11
map("n", "<Leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint (F9)" })
map("n", "<Leader>dB", function() require("dap").clear_breakpoints() end, { desc = "Clear Breakpoints" })
map("n", "<Leader>dc", function() require("dap").continue() end, { desc = "Start/Continue (F5)" })
map("n", "<Leader>dh", function() require("dap.ui.widgets").hover() end, { desc = "Debugger Hover" })
map("n", "<Leader>di", function() require("dap").step_into() end, { desc = "Step Into (F11)" })
map("n", "<Leader>dj", "<CMD>e $PWD/.vscode/launch.json<CR><CMD>w ++p<CR>", { desc = "Open workspace DAP config" })
map("n", "<Leader>do", function() require("dap").step_over() end, { desc = "Step Over (F10)" })
map("n", "<Leader>dO", function() require("dap").step_out() end, { desc = "Step Out (S-F11)" })
map("n", "<Leader>dp", function() require("dap").pause() end, { desc = "Pause (F6)" })
map("n", "<Leader>dq", function() require("dap").close() end, { desc = "Close Session" })
map("n", "<Leader>dQ", function() require("dap").terminate() end, { desc = "Terminate Session (S-F5)" })
map("n", "<Leader>dr", function() require("dap").restart_frame() end, { desc = "Restart (C-F5)" })
map("n", "<Leader>dR", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" })
map("n", "<Leader>ds", function() require("dap").run_to_cursor() end, { desc = "Run To Cursor" })
map("n", "<F21>",
	function()
		vim.ui.input({ prompt = "Condition: " },
			function(condition) if condition then require("dap").set_breakpoint(condition) end end)
	end,
	{ desc = "Debugger: Conditional Breakpoint" }) -- Shift+F9
map("n", "<Leader>dC",
	function()
		vim.ui.input({ prompt = "Condition: " },
			function(condition) if condition then require("dap").set_breakpoint(condition) end end)
	end,
	{ desc = "Conditional Breakpoint (S-F9)" })
-- map("v", "<Leader>dE", function() require("dapui").eval() end, {desc = "Evaluate Input" })
-- map("n", "<Leader>du", function() require("dapui").toggle() end, {desc = "Toggle Debugger UI" })
map("n", "<Leader>dE",
	function()
		vim.ui.input({ prompt = "Expression: " },
			function(expr) if expr then require("dapui").eval(expr, { enter = true }) end end)
	end,
	{ desc = "Evaluate Input" })
map("n", "<Leader>du", function() require("dap-view").toggle(true) end, { desc = "Toggle Debugger UI" })


-- Package/Plugin Management
map("n", "<Leader>pi", "<CMD>Lazy<CR>", { desc = "Lazy" })
map("n", "<Leader>pm", "<CMD>Mason<CR>", { desc = "Mason" })
map("n", "<Leader>pz",
	function() require("neo-tree.command").execute({ dir = os.getenv("HOME") .. "/.local/share/chezmoi" }) end,
	{ desc = "cd chezmoi" })
map("n", "<Leader>pc", function() require("neo-tree.command").execute({ dir = vim.fn.stdpath("config") }) end,
	{ desc = "cd config" })
map("n", "<Leader>pa", function()
	vim.ui.input({ prompt = "Edit plugin spec" }, function(input)
		if input ~= nil then
			local file = vim.fn.stdpath("config") .. "/lua/plugins/" .. input .. ".lua"
			vim.notify("Editing " .. file, "info")
			vim.cmd("e " .. file)
		end
	end)
end, { desc = "add plugin" })

-- Blink completion
vim.keymap.del("i", "<Tab>")

-- Extras/Fun stuff
map("n", "<Leader>x", "", { desc = "Extras" })
map("n", "<Leader>xa", function() require("ascii").preview() end, { desc = "Ascii art picker" })
