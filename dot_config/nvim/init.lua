local map = require("functions").map
local icons = require("stuff.icons")
vim.g.mapleader = " "

--- Plugins {{{
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
			vim.cmd("TSUpdate")
		elseif name == "mason" and kind == "update" then
			if not ev.data.active then vim.cmd.packadd("mason.nvim") end
			vim.cmd("MasonUpdate")
		elseif name == "fff" and (kind == "update" or kind == "install") then
			if not ev.data.active then vim.cmd.packadd("fff") end
			require("fff.download").download_or_build_binary()
		end
	end,
})

local gh = require("functions").gh
vim.cmd.packadd("nvim.undotree")
vim.pack.add({
	{ src = gh("MagicDuck/grug-far.nvim") },
	{ src = gh("MeanderingProgrammer/render-markdown.nvim"), vim.version.range("*") },
	{ src = gh("bngarren/checkmate.nvim") },
	{ src = gh("akinsho/bufferline.nvim"), vim.version.range("*") },
	{ src = gh("aserowy/tmux.nvim") },
	{ src = gh("brenoprata10/nvim-highlight-colors") },
	{ src = gh("esmuellert/codediff.nvim") },
	{ src = gh("folke/flash.nvim") },
	{ src = gh("folke/snacks.nvim") },
	{ src = gh("folke/todo-comments.nvim") },
	{ src = gh("folke/which-key.nvim") },
	{ src = gh("igorlfs/nvim-dap-view"), version = vim.version.range("1.*") },
	{ src = gh("jbyuki/nabla.nvim") },
	{ src = gh("kylechui/nvim-surround") },
	{ src = gh("lewis6991/gitsigns.nvim") },
	{ src = gh("mason-org/mason-lspconfig.nvim") },
	{ src = gh("mason-org/mason.nvim"), version = vim.version.range("*") },
	{ src = gh("mfussenegger/nvim-dap") },
	{ src = gh("mfussenegger/nvim-dap-python") },
	{ src = gh("mikavilpas/blink-ripgrep.nvim"), version = vim.version.range("*") },
	{ src = gh("neovim/nvim-lspconfig"), version = vim.version.range("*") },
	{ src = gh("nvim-lualine/lualine.nvim") },
	{ src = gh("nvim-mini/mini.align") },
	{ src = gh("nvim-mini/mini.bracketed") },
	{ src = gh("nvim-mini/mini.files") },
	{ src = gh("nvim-mini/mini.icons") },
	{ src = gh("nvim-treesitter/nvim-treesitter") },
	{ src = gh("nvim-treesitter/nvim-treesitter-context") },
	{ src = gh("nvim-treesitter/nvim-treesitter-textobjects") },
	{ src = gh("rafamadriz/friendly-snippets") },
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
	{ src = gh("sindrets/diffview.nvim") },
	{ src = gh("stevearc/conform.nvim") },
	{ src = gh("windwp/nvim-autopairs") },
	{ src = gh("sainnhe/everforest") },
	{ src = gh("mcauley-penney/techbase.nvim") },
	{ src = gh("olimorris/onedarkpro.nvim") },
	{ src = gh("sainnhe/gruvbox-material") },
	-- { src = gh("folke/tokyonight.nvim") },
	-- { src = gh("gbprod/nord.nvim") },
	-- { src = gh("sainnhe/sonokai") },
	-- { src = gh("vague-theme/vague.nvim") },
	-- { src = gh("rose-pine/neovim"), name = "rose-pine" },
	-- { src = gh("sainnhe/edge") },
})

--- ColorSchemes --- {{{
require("onedarkpro").setup({
	styles = { comments = "italic", keywords = "bold, italic", conditionals = "italic" },
	highlights = { NormalFloat = { link = "Normal" }, FloatBorder = { link = "UltestBorder" } },
	options = { transparency = true },
})

require("techbase").setup({
	italic_comments = true,
})

vim.g.gruvbox_material_foreground = "material"
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_better_performance = 1
vim.g.gruvbox_material_transparent_background = 1
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("custom_highlights_gruvboxmaterial", {}),
	pattern = "gruvbox-material",
	callback = function()
		local config = vim.fn["gruvbox_material#get_configuration"]()
		local palette = vim.fn["gruvbox_material#get_palette"](config.background, config.foreground, config.colors_override)
		local set_hl = vim.fn["gruvbox_material#highlight"]
		set_hl("DiffText", palette.none, palette.bg_visual_red)
	end,
	desc = "Set custom highlights specific to gruvbox-material",
})

vim.g.edge_style = "default"
vim.g.edge_better_performance = 1
vim.g.edge_enable_italic = 1
vim.g.everforest_background = "medium"
vim.g.everforest_better_performance = 1
vim.g.everforest_enable_italic = 1
vim.g.everforest_transparent_background = 1
if vim.env.TERM == "linux" then
	vim.cmd.colorscheme("default")
else
	vim.cmd.colorscheme("gruvbox-material")
end
--- }}}

--- statusline --- {{{
local modes = {
	["n"] = { name = "n", hl = "StatuslineNormal" },
	["no"] = { name = "no", hl = "StatuslineNormal" },
	["v"] = { name = "v", hl = "StatuslineVisual" },
	["V"] = { name = "V", hl = "StatuslineVisual" },
	["\22"] = { name = "^V", hl = "StatuslineVisual" },
	["s"] = { name = "s", hl = "StatuslineVisual" },
	["S"] = { name = "S", hl = "StatuslineVisual" },
	["\19"] = { name = "^S", hl = "StatuslineVisual" },
	["i"] = { name = "i", hl = "StatuslineInsert" },
	["ic"] = { name = "ic", hl = "StatuslineInsert" },
	["R"] = { name = "R", hl = "StatuslineReplace" },
	["Rv"] = { name = "Rv", hl = "StatuslineReplace" },
	["c"] = { name = "c", hl = "StatuslineCommand" },
	["cv"] = { name = "cv", hl = "StatuslineCommand" },
	["ce"] = { name = "ce", hl = "StatuslineCommand" },
	["r"] = { name = "r", hl = "StatuslineCommand" },
	["rm"] = { name = "rm", hl = "StatuslineCommand" },
	["r?"] = { name = "r?", hl = "StatuslineCommand" },
	["!"] = { name = "!", hl = "StatuslineCommand" },
	["t"] = { name = "t", hl = "StatuslineTerminal" },
}
local function get_macro()
	local reg = vim.fn.reg_recording()
	if reg == "" then return "" end
	return "recording @" .. reg
end
local function get_filesize(bufnr)
	local file = vim.api.nvim_buf_get_name(bufnr)
	if file == "" or #file == 0 then return "" end
	local size = vim.fn.getfsize(file)
	if size <= 0 then return "" end
	local units = { "B", "KB", "MB", "GB" }
	local i = 1
	while size > 1024 and i < #units do
		size = size / 1024
		i = i + 1
	end
	return string.format("%.1f%s", size, units[i])
end
local function get_diagnostics(bufnr)
	if not #vim.lsp.get_clients({ bufnr = bufnr }) then return "" end
	local count = {
		errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }),
		warnings = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN }),
		info = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO }),
	}
	local res = {}
	if count.errors > 0 then table.insert(res, "%4* " .. count.errors .. "%*") end
	if count.warnings > 0 then table.insert(res, "%5* " .. count.warnings .. "%*") end
	if count.info > 0 then table.insert(res, "%3* " .. count.info .. "%*") end
	if #res == 0 then return "" end
	return " " .. table.concat(res, " ")
end
local function get_truncated_filename(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then return "[No Name]" end
	local rel_path = vim.fn.fnamemodify(name, ":~:.")
	if #rel_path > 40 then rel_path = vim.fn.pathshorten(rel_path, 3) end
	return rel_path
end
function get_lsp_formatter(bufnr)
	local out = ""
	if #vim.lsp.get_clients({ bufnr = bufnr }) > 0 then out = out .. " " end
	local _, conform = pcall(require, "conform")
	if not conform then return "Conform not installed" end
	if #conform.list_formatters_for_buffer(bufnr) > 0 then out = out .. "󰉼" end
	return out
end
local function set_statusline_highlights()
	vim.api.nvim_set_hl(0, "StatuslineNormal", { fg = "#1e1e2e", bg = "#89b4fa", bold = true })
	vim.api.nvim_set_hl(0, "StatuslineInsert", { fg = "#1e1e2e", bg = "#a6e3a1", bold = true })
	vim.api.nvim_set_hl(0, "StatuslineVisual", { fg = "#1e1e2e", bg = "#f9e2af", bold = true })
	vim.api.nvim_set_hl(0, "StatuslineReplace", { fg = "#1e1e2e", bg = "#f38ba8", bold = true })
	vim.api.nvim_set_hl(0, "StatuslineCommand", { fg = "#1e1e2e", bg = "#cba6f7", bold = true })
	vim.api.nvim_set_hl(0, "StatuslineTerminal", { fg = "#1e1e2e", bg = "#94e2d5", bold = true })
	vim.api.nvim_set_hl(0, "StatuslineSection", { fg = "#888888", bg = "#444444" })
	vim.api.nvim_set_hl(0, "User1", { link = "Purple" })
	vim.api.nvim_set_hl(0, "User2", { link = "Green" })
	vim.api.nvim_set_hl(0, "User3", { link = "Blue" })
	vim.api.nvim_set_hl(0, "User4", { link = "Red" })
	vim.api.nvim_set_hl(0, "User5", { link = "Yellow" })
	vim.api.nvim_set_hl(0, "User6", { link = "Aqua" })
	vim.api.nvim_set_hl(0, "User7", { link = "Orange" })
	vim.api.nvim_set_hl(0, "User8", { link = "Grey" })
	vim.api.nvim_set_hl(0, "User9", { link = "OkMsg" })
end
set_statusline_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_statusline_highlights,
})
function _G.my_statusline()
	local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	local bufnr = vim.api.nvim_win_get_buf(winid)
	local is_active = (winid == vim.api.nvim_get_current_win())

	local mode_code = vim.api.nvim_get_mode().mode
	local mode_info = modes[mode_code] or { name = "UNKNOWN", hl = "StatuslineNormal" }
	local mode_str = string.format("%%#%s# %s %%*", "StatuslineSection", mode_info.name)
	if is_active then mode_str = string.format("%%#%s# %s %%*", mode_info.hl, mode_info.name) end
	local macro = ""
	if is_active then macro = " %#RedBold#" .. get_macro() .. "%*" end
	local filename = " %1*" .. get_truncated_filename(bufnr) .. "%*"
	local bufargs = "%8*%m%r%* "
	local buf = "%8*" .. bufnr .. "%*"
	local filesize = " %8*" .. (get_filesize(bufnr) or "0B") .. "%*"
	local filetype = " %6*" .. (vim.bo[bufnr].filetype ~= "" and vim.bo[bufnr].filetype or ""):upper() .. "%*"
	local encoding = "  %4*" .. (vim.bo[bufnr].fileencoding ~= "" and vim.bo[bufnr].fileencoding or vim.o.encoding):upper() .. "%* "
	local lineending = " %3*" .. (vim.bo[bufnr].fileformat:upper() == "UNIX" and "" or (vim.bo[bufnr].fileformat:upper() == "DOS" and "")) .. "%*"
	local location = " %3*%l:%c %p%% %*"
	local diagnostics = get_diagnostics(bufnr) .. "%*  "
	local lsp_formatter = "%3*" .. get_lsp_formatter(bufnr) .. "%* "
	return table.concat({
		mode_str,
		filename,
		bufargs,
		buf,
		filesize,
		location,
		macro,
		"%=", -- Alignment separator (pushes following items to the right)
		diagnostics,
		lsp_formatter,
		filetype,
		encoding,
		lineending,
	})
end

vim.o.statusline = "%!v:lua.my_statusline()"
--- }}}

--- mini.files --- {{{
require("mini.files").setup({
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
})
local MiniFiles = require("mini.files")
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
					local nameStartCol = line:find(vim.pesc(entry.name)) or 0
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
		for part in filePath:gmatch("[^/]+") do
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
--- }}}

--- conform {{{
---@diagnostic disable-next-line: param-type-mismatch
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
		r = { "air" },
		htmldjango = { "djlint" },
		yaml = { "prettier" },
		json = { "fixjson" },
		css = { "prettier" },
		javascript = { "prettier" },
		gotmpl = { "shfmt" },
		xml = { "xmlformat" },
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
})
map("n", "<Leader>lc", "<CMD>ConformInfo<CR>", { desc = "Formatter info" })
map("n", "<Leader>bf", function() require("conform").format({ async = true }) end, { desc = "format buffer" })
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.api.nvim_create_user_command("FormatDisable", function() vim.b.autoformat = false end, { desc = "Disable autoformat-on-save" })
vim.api.nvim_create_user_command("FormatEnable", function() vim.b.autoformat = true end, { desc = "Enable autoformat-on-save" })
--- }}}

--- blink --- {{{
---@diagnostic disable-next-line: param-type-mismatch
require("blink.cmp").setup({
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
			auto_show_delay_ms = 200,
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
			auto_show = false,
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
				enabled = function() return vim.fs.root(0, ".git") ~= nil end,
				module = "blink-ripgrep",
				name = "rg",
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
})
vim.api.nvim_set_hl(0, "BlinkCmpKindRipgrepRipgrep", { link = "BlinkCmpKindKey" })
--- }}}

--- html-css {{{
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "html", "htmldjango" },
	once = true,
	callback = function()
		-- vim.pack.add({ { src = gh("jezda1337/nvim-html-css") } })
		vim.pack.add({ { src = gh("marioy47/nvim-html-css"), version = "bda9a78", name = "html-css" } })
		require("html-css").setup({
			enable_on = { "html", "htmldjango", "php", "templ" },
			handlers = {
				definition = {
					bind = "gd",
				},
				hover = {
					bind = "K",
					wrap = true,
					border = "none",
					position = "cursor",
				},
			},
			documentation = {
				auto_show = true,
			},
			peek = {
				enabled = true,
				border = "rounded",
				position = "center",
				width = 0.5,
				height = 0.5,
				focus = true,
				style = "minimal",
			},
			style_sheets = {
				"https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css",
			},
		})
	end,
})
--- }}}

--- snacks {{{
require("snacks").setup({
	bigfile = { enabled = true, line_length = 99999 },
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
	explorer = { enabled = false },
	dashboard = {
		preset = {
			header = require("stuff.ascii").cat,
			keys = {
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
					action = ":SessionLoad",
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
		},
	},
	image = { enabled = false, math = { enabled = false } },
	indent = {
		enabled = true,
		scope = { only_current = true },
		filter = function(buf, _win)
			return vim.g.snacks_indent ~= false
				and vim.b[buf].snacks_indent ~= false
				and vim.bo[buf].buftype == ""
				and vim.bo[buf].filetype ~= "snacks_picker_preview"
		end,
	},
	input = { enabled = true },
	picker = {
		layout = function()
			local layouts = require("snacks.picker.config.layouts")
			---@type snacks.picker.layout.Config
			local cfg = layouts["default"]
			if vim.o.columns < 140 then
				---@type snacks.picker.layout.Config
				cfg = vim.deepcopy(layouts["vertical"])
				cfg.layout.width = 0.8
				cfg.layout.min_width = 90
				cfg.layout[3] = vim.tbl_deep_extend("force", cfg.layout[3], {
					win = "preview",
					height = 0.8,
					border = "top",
					wo = { wrap = true, number = false, statuscolumn = "%l ", relativenumber = false, foldcolumn = "0" },
				})
			end
			return cfg
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
		win = {
			wo = {
				statuscolumn = "%l %s",
				winhighlight = "Normal:Normal,FloatBorder:SnacksPickerBorder,FloatTitle:SnacksPickerTitle",
			},
			footer_pos = "center",
			title_pos = "center",
			relative = "win",
		},
	},
	statuscolumn = { enabled = true },
	zen = { toggles = { dim = false }, show = { statusline = true } },
})
local Snacks = require("snacks")
vim.print = function(...) Snacks.debug.inspect(...) end
map("n", "<leader>c", function() Snacks.bufdelete() end, { desc = "Close buffer" })
map("n", "<leader>bc", function() Snacks.bufdelete.other() end, { desc = "Close all other buffers" })
map("n", "<Leader>fe", function() Snacks.explorer() end, { desc = "File explorer" })
map({ "n", "t", "i" }, "<F7>", function() Snacks.terminal.toggle() end, { desc = "toggle terminal" })
map("n", "<Leader>R", function() Snacks.rename.rename_file() end, { desc = "Rename file" })
local bufferline_avail, _ = pcall(require, "bufferline")
if not bufferline_avail then map("n", "vv", function() Snacks.picker.buffers() end, { desc = "buffers" }) end
local fff_avail, _ = pcall(require, "fff")
if not fff_avail then
	map("n", "ff", function() Snacks.picker.files() end, { desc = "files" })
	map("n", "<Leader>fw", function() Snacks.picker.grep({ cmd = "rg" }) end, { desc = "word" })
	map({ "n", "x" }, "<Leader>f*", function() Snacks.picker.grep_word() end, { desc = "grep current selection" })
end
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
map("n", "<Leader>fh", function() Snacks.picker.help() end, { desc = "help pages" })
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
map("n", "<Leader>uZ", function() Snacks.zen.zen() end, { desc = "Zen mode" })
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
vim.api.nvim_set_hl(0, "SnacksTitle", { link = "Title" })
vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { link = "Ignore" })
vim.api.nvim_set_hl(0, "SnacksPickerGitStatussdfIgnored", { link = "Ignore" })
--- }}}

--- which-key {{{
---@diagnostic disable-next-line: missing-fields, param-type-mismatch
require("which-key").setup({
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
	---@diagnostic disable-next-line: missing-fields
	win = {
		no_overlap = false,
	},
})
vim.api.nvim_set_hl(0, "WhichKeyNormal", { link = "Normal" })
vim.api.nvim_set_hl(0, "WhichKeyTitle", { link = "Green" })
vim.api.nvim_set_hl(0, "WhichKeyBorder", { link = "Blue" })
--- }}}

--- bufferline {{{
require("bufferline").setup({
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
})
map("n", "vv", "<CMD>BufferLinePick<CR>", { desc = "Pick buffer" })
map("n", "<leader>bx", "<CMD>BufferLinePickClose<CR>", { desc = "Pick buffer to close" })
vim.api.nvim_set_hl(0, "BufferLineFill", { link = "Normal" })
--- }}}

--- nvim-autopairs {{{
require("nvim-autopairs").setup({})
--- }}}

--- mini.align {{{
require("mini.align").setup({})
--- }}}

--- mini.bracketed {{{
require("mini.bracketed").setup({
	comment = { suffix = "#" },
	file = { suffix = "e" },
	indent = { suffix = "h" },
})
--- }}}

--- flash {{{
require("flash").setup({
	modes = {
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
})
---@type Flash.Commands
local flash = require("flash")
map({ "n", "x", "o" }, "+", function() flash.jump() end, { desc = "Flash Jump" })
map({ "n", "x", "o" }, "-", function() flash.treesitter() end, { desc = "Flash Treesitter" })
map("o", "r", function() flash.remote() end, { desc = "Flash Remote" })
--- }}}

--- grug-far {{{
require("grug-far").setup()
--- }}}

--- Mason --- {{{
require("mason").setup()
map("n", "<Leader>pm", "<CMD>Mason<CR>", { desc = "Mason" })
local registry = require("mason-registry")
local installs = { "marksman", "prettier", "fixjson" }
if vim.fn.has("win32") == 0 then
	vim.list_extend(installs, {
		"ruff",
		"ty",
		"debugpy",
		"tombi",
		"bash-language-server",
		"docker-language-server",
		"emmylua_ls",
		"stylua",
		"tree-sitter-cli",
	})
end
registry.refresh(function()
	for _, pkg_name in ipairs(installs) do
		if not registry.is_installed(pkg_name) then
			vim.api.nvim_echo({ { "Installing " .. pkg_name .. " via Mason...", "Orange" } }, false, {})
			local pkg = registry.get_package(pkg_name)
			pkg:install()
		end
	end
end)
require("mason-lspconfig").setup()
--- }}}

--- TreeSitter --- {{{
--stylua: ignore
local languages = {
	"bash", "c", "css", "diff", "dockerfile", "git_config", "gitignore", "json", "lua", "latex",
	"luadoc", "markdown", "markdown_inline", "python", "query", "readline", "ssh_config",
	"toml", "typescript", "vim", "vimdoc", "yaml",
}
require("nvim-treesitter").install(languages)
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter.setup", {}),
	callback = function(args)
		local buf = args.buf
		local filetype = args.match
		local language = vim.treesitter.language.get_lang(filetype) or filetype
		if not vim.treesitter.language.add(language) then return end
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		-- vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.treesitter.start(buf, language)
	end,
})

require("treesitter-context").setup({
	multiwindow = true,
	max_lines = 5,
	multiline_threshold = 1,
	mode = "topline",
})

require("nvim-treesitter-textobjects").setup({
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
})
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
--- }}}

--- DAP --- {{{
require("dap-view").setup(vim.tbl_deep_extend("force", require("dap-view.config").config, {
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
}))
require("dap-python").setup("uv")
local dap = require("dap")
dap.defaults.fallback.stepping_granularity = "line"
dap.defaults.fallback.auto_continue_if_many_stopped = false
--stylua: ignore start
map("n", "<F5>", function() dap.continue() end, { desc = "Debugger: Start" })
map("n", "<F6>", function() dap.pause() end, { desc = "Debugger: Pause" })
map("n", "<F9>", function() dap.toggle_breakpoint() end, { desc = "Debugger: Toggle Breakpoint" })
map("n", "<F10>", function() dap.step_over() end, { desc = "Debugger: Step Over" })
map("n", "<F11>", function() dap.step_into() end, { desc = "Debugger: Step Into" })
map("n", "<F17>", function() dap.terminate() end, { desc = "Debugger: Stop" })
map("n", "<F21>", function() vim.ui.input({ prompt = "Condition: " }, function(cond) if cond then dap.set_breakpoint(cond) end end) end, { desc = "Debugger: Conditional Breakpoint" })
map("n", "<F23>", function() dap.step_out() end, { desc = "Debugger: Step Out" })
map("n", "<F29>", function() dap.restart_frame() end, { desc = "Debugger: Restart" })
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
map("n", "<Leader>dC", function() vim.ui.input({ prompt = "Condition: " }, function(cond) if cond then dap.set_breakpoint(cond) end end) end, { desc = "Conditional Breakpoint (S-F9)" })
map("n", "<Leader>du", function() require("dap-view").toggle(true) end, { desc = "Toggle Debugger UI" })
vim.fn.sign_define("DapBreakpoint", { text = icons.debug.breakpoint, texthl = "DiagnosticSignHint" })
vim.fn.sign_define("DapBreakpointCondition", { text = icons.debug.conditional, texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DapLogPoint", { text = icons.debug.logpoint, texthl = "DiagnosticSignOk" })
vim.fn.sign_define("DapStopped", { text = icons.debug.stopped, texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DapBreakpointRejected", { text = icons.debug.rejected, texthl = "DiagnosticSignError" })
--stylua: ignore end
--- }}}

--- nvim-surround {{{
require("nvim-surround").setup({})
--- }}}

--- tmux {{{
if vim.env.TMUX ~= nil then
	require("tmux").setup({})
else
	map("n", "<C-h>", "<C-w>h", { desc = "Move to window left" })
	map("n", "<C-j>", "<C-w>j", { desc = "Move to window above" })
	map("n", "<C-k>", "<C-w>k", { desc = "Move to window below" })
	map("n", "<C-l>", "<C-w>l", { desc = "Move to window right" })
end
--- }}}

--- mini.icons {{{
local style
if vim.env.TERM == "linux" then
	style = "ascii"
else
	style = "glyph"
end
require("mini.icons").setup({
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
})
package.preload["nvim-web-devicons"] = function()
	require("mini.icons").mock_nvim_web_devicons()
	return package.loaded["nvim-web-devicons"]
end
--- }}}

--- gitsigns {{{
require("gitsigns").setup({
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
})
vim.api.nvim_set_hl(0, "GitSignsAddInline", { link = "DiffAdd" })
vim.api.nvim_set_hl(0, "GitSignsChangeInline", { link = "DiffChange" })
vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { link = "DiffText" })
--- }}}

--- fff {{{
if vim.fs.root(0, ".git") ~= nil then
	vim.pack.add({ { src = gh("dmtrKovalenko/fff"), version = vim.version.range("*") } })
	require("fff").setup({
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
		git = { status_text_color = true },
		debug = { enabled = true, show_scores = false },
	})
	map("n", "ff", function() require("fff").find_files({ wait_fot_index_ms = 1 }) end, { desc = "FFFind files" })
	map("n", "<leader>fw", function() require("fff").live_grep() end, { desc = "grep" })
	map("n", "<leader>fj", function() require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } }) end, { desc = "fuzzy grep" })
	map({ "n", "x" }, "<leader>f*", function() require("fff").live_grep_under_cursor() end, { desc = "current word / selection" })
end
--- }}}

--- diffview {{{
local da = require("diffview.actions")
require("diffview").setup({
	enhanced_diff_hl = true,
	view = { default = { disable_diagnostics = true, winbar_info = true }, merge_tool = { layout = "diff3_mixed" } },
	file_panel = { win_config = { position = "bottom", height = 10 } },
	file_history_panel = { win_config = { type = "split", position = "bottom", height = 10 } },
	keymaps = {
		disable_defaults = true,
		view = {
			{ "n", "<Leader>q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
			{ "n", "<Leader>e", da.toggle_files, { desc = "toggle file panel" } },
			{ "n", "gf", da.goto_file_edit, { desc = "Open file in previous tabpage" } },
			{ "n", "g?", da.help("view"), { desc = "Open help panel" } },
			{ "n", "co", da.conflict_choose("ours"), { desc = "Choose conflict --ours" } },
			{ "n", "ct", da.conflict_choose("theirs"), { desc = "Choose conflict --theirs" } },
			{ "n", "cb", da.conflict_choose("base"), { desc = "Choose conflict --base" } },
			{ "n", "ca", da.conflict_choose("all"), { desc = "Choose conflict --all" } },
			{ "n", "cn", da.conflict_choose("none"), { desc = "Choose conflict --none" } },
		},
		file_panel = {
			{ "n", "q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
			{ "n", "<Leader>e", da.toggle_files, { desc = "toggle file panel" } },
			{ "n", "j", da.next_entry, { desc = "Next file entry" } },
			{ "n", "<down>", da.select_next_entry, { desc = "Select next file entry" } },
			{ "n", "k", da.prev_entry, { desc = "Previous file entry" } },
			{ "n", "<up>", da.select_prev_entry, { desc = "Select previous file entry" } },
			{ "n", "<cr>", da.select_entry, { desc = "Open diff for selected entry" } },
			{ "n", "s", da.toggle_stage_entry, { desc = "Stage/unstage entry" } },
			{ "n", "S", da.stage_all, { desc = "Stage all entries" } },
			{ "n", "U", da.unstage_all, { desc = "Unstage all entries" } },
			{ "n", "[x", da.prev_conflict, { desc = "Go to prev conflict" } },
			{ "n", "]x", da.next_conflict, { desc = "Go to next conflict" } },
			{ "n", "gf", da.goto_file_edit, { desc = "Open file in previous tabpage" } },
			{ "n", "co", da.conflict_choose_all("ours"), { desc = "Choose conflict --ours" } },
			{ "n", "ct", da.conflict_choose_all("theirs"), { desc = "Choose conflict --theirs" } },
			{ "n", "cb", da.conflict_choose_all("base"), { desc = "Choose conflict --base" } },
			{ "n", "l", da.open_fold, { desc = "Expand fold" } },
			{ "n", "h", da.close_fold, { desc = "Collapse fold" } },
			{ "n", "t", da.listing_style, { desc = "Toggle list/tree views" } },
			{ "n", "L", da.open_commit_log, { desc = "Open commit log panel" } },
			{ "n", "g?", da.help("file_panel"), { desc = "Open help panel" } },
			{
				"n",
				"cc",
				function()
					vim.ui.input({ prompt = "Commit message: " }, function(msg)
						if not msg then return end
						local results = vim.system({ "git", "commit", "-m", msg }, { text = true }):wait()
						vim.notify(results.stdout or "", vim.log.levels.INFO, { title = "Commit" })
					end)
				end,
			},
			{
				"n",
				"cx",
				function()
					local results = vim.system({ "git", "commit", "--amend", "--no-edit" }, { text = true }):wait()
					vim.notify(results.stdout or "", vim.log.levels.INFO, { title = "Commit amend" })
				end,
			},
		},
		file_history_panel = {
			{ "n", "q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
			{ "n", "<Leader>e", da.toggle_files, { desc = "toggle file panel" } },
			{ "n", "j", da.next_entry, { desc = "Next log entry" } },
			{ "n", "<down>", da.select_next_entry, { desc = "Select next log entry" } },
			{ "n", "k", da.prev_entry, { desc = "Previous log entry" } },
			{ "n", "<up>", da.select_prev_entry, { desc = "Select previous file entry" } },
			{ "n", "<cr>", da.select_entry, { desc = "Open diff for selected entry" } },
			{ "n", "gd", da.open_in_diffview, { desc = "Open entry in diffview" } },
			{ "n", "y", da.copy_hash, { desc = "Copy commit hash" } },
			{ "n", "L", da.open_commit_log, { desc = "Show commit details" } },
			{ "n", "gf", da.goto_file_edit, { desc = "Open file in previous tabpage" } },
			{ "n", "g?", da.help("file_history_panel"), { desc = "Open help panel" } },
		},
		help_panel = { { "n", "q", da.close, { desc = "Close help menu" } }, { "n", "<ESC>", da.close, { desc = "Close help menu" } } },
	},
})
--- }}}

--- codediff {{{
vim.schedule(
	function()
		require("codediff").setup({
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
			explorer = {
				file_filter = {
					ignore = {
						".git/**",
						"*.pyc",
						"*.pyo",
						"__pycache__",
						"node_modules",
						"*.egg-info",
						".venv",
						"*.png",
						"*.jpg",
						"*.jpeg",
						"*.csv",
						"*.tiff",
						"*.svs",
						"*.db",
						"*.ipynb",
					},
				},
			},
		})
	end
)
--- }}}

--- obsidian {{{
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	pattern = "**/[Oo]bsidian/**",
	once = true,
	callback = function()
		vim.pack.add({
			{ src = gh("obsidian-nvim/obsidian.nvim"), version = vim.version.range("*") },
		})
		require("obsidian").setup({
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
		})
		map("n", "<Leader>mt", "<CMD>Obsidian today<CR>", { desc = "today's note" })
		map("n", "<Leader>my", "<CMD>Obsidian yesterday<CR>", { desc = "yesterday's note" })
		map("n", "<Leader>md", "<CMD>Obsidian dailies -48 0<CR>", { desc = "find daily notes" })
		map("n", "<Leader>mn", "<CMD>Obsidian new_from_template<CR>", { desc = "new from template" })
		map("n", "<leader>mo", "<CMD>cd ~/Documents/Obsidian<CR>", { desc = "cd vault" })
		vim.api.nvim_create_autocmd("User", {
			pattern = "ObsidianNoteEnter",
			callback = function()
				vim.keymap.set("n", "<CR>", function()
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
	end,
})
--- }}}

--- render-markdown {{{
require("render-markdown").setup({
	ignore = function() return vim.bo.buftype ~= "" end,
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
})
--- }}}

--- checkmate {{{
---@diagnostic disable-next-line: missing-fields, param-type-mismatch
require("checkmate").setup({
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
					return { fg = "black", sp = "red", undercurl = true }
				elseif remaining > -1 then
					return { fg = "black", bg = "#ff5555", bold = true }
				elseif remaining > -7 then
					return { fg = "black", bg = "#ff6700", bold = true }
				elseif remaining > -14 then
					return { fg = "black", bg = "orange" }
				elseif remaining > -21 then
					return { fg = "black", bg = "gold" }
				elseif remaining > -28 then
					return { fg = "black", bg = "greenyellow" }
				else
					return { fg = "green" }
				end
			end,
			sort_order = 15,
		},
	},
})
--- }}}

--- todo-comments {{{
require("todo-comments").setup({
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
})
--- }}}

--- nvim-highlight-colors {{{
require("nvim-highlight-colors").setup({
	exclude_filetypes = { "bigfile" },
})
--- }}}
--- }}}

--- Mappings {{{
-- Basic operations
map("n", "<Leader>q", "<CMD>q<CR>", { desc = "Quit window" })
map("n", "<Leader>Q", "<CMD>qa<CR>", { desc = "Quit nvim" })
map("n", "<Leader>w", "<CMD>w<CR>", { desc = "Save buffer" })
map("n", "<Leader>.", "<CMD>cd %:h<CR>", { desc = "cd here" })
map("n", "<Leader><space>", "<ESC>", { desc = "" })
map("t", "<ESC>", "<C-\\><C-n>", { desc = "Escape terminal mode" })
map("i", "<S-Tab>", "<C-d>", { desc = "Unindent 1 level" })
map("n", "J", "mzJ`z", { desc = "Shift J without moving cursor", noremap = false })
map("n", "<BS>", "<C-^>", { desc = "Switch to prev file" })
map("n", "<Leader>x", "<CMD>tabclose<CR>", { desc = ":tabclose" })
map("n", "<Leader>gx", "<CMD>tabclose<CR>", { desc = ":tabclose" })

-- System clipboard
map({ "n" }, "<C-c>", '"+yy', { desc = "Copy line to system clipboard" })
map({ "v" }, "<C-c>", '"+y', { desc = "Copy selection to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste system clipboard" })
map({ "i", "c" }, "<C-v>", "<C-r>+", { desc = "Paste system clipboard" })

-- Movement
map("n", "<C-u>", "<C-u>zz", { desc = "Jump up half page" })
map("n", "<C-d>", "<C-d>zz", { desc = "Jump down half page" })
map("n", "<C-o>", "<C-o>zz", { desc = "Jump to previous location" })
map("n", "<C-i>", "<C-i>zz", { desc = "Jump to next location" })
map("n", "n", "nzzzv", { desc = "Jump to next search result" })
map("n", "N", "Nzzzv", { desc = "Jump to previous search result" })
map("n", "<C-UP>", "<C-y>", { desc = "Scroll up" })
map("n", "<C-DOWN>", "<C-e>", { desc = "Scroll down" })

-- Buffers
map("n", "<Leader>bA", "<CMD>%y+<CR><CR>", { desc = "Copy whole buffer to clipboard" })
map("n", "<Leader>bD", function() require("functions").DOS_to_Unix() end, { desc = "DOS to Unix" })
map("n", "<Leader>bf", function() vim.lsp.buf.format() end, { desc = "format buffer" })
map("n", "<Leader>bz", "<CMD>set foldlevel=2<CR>", { desc = "set foldlevel=2" })

-- LSP
map("n", "<Leader>la", function() vim.lsp.buf.code_action() end, { desc = "code actions" })
map("n", "<Leader>ld", function() vim.diagnostic.open_float() end, { desc = "show diagnostic" })
map("n", "<Leader>lc", function() vim.diagnostic.setqflist() end, { desc = "qflist diagnostics" })
map("n", "<Leader>lr", function() vim.lsp.buf.rename() end, { desc = "rename symbol" })
map("n", "<Leader>lw", function() vim.lsp.buf.workspace_diagnostics() end, { desc = "workspace diagnostics" })
map("n", "<Leader>li", "<CMD>checkhealth vim.lsp<CR>", { desc = "LSP info" })
map("n", "gco", "o<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment below" })
map("n", "gcO", "O<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add comment above" })

-- Packages
map("n", "<leader>pu", function() vim.pack.update() end, { desc = "vim.pack.update()" })
map("n", "<leader>pi", function() vim.pack.update(nil, { offline = true }) end, { desc = "[offline] vim.pack.update()" })
map("n", "<leader>pp", function() vim.cmd.source(vim.fn.stdpath("config") .. "/init.lua") end, { desc = "source init.lua" })
--- }}}

--- Highlights {{{
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { italic = true, bold = true })
vim.api.nvim_set_hl(0, "MatchParen", { link = "Error" })
--- }}}

--- Custom Filetypes {{{
vim.filetype.add({
	filename = {
		["dot_bashrc"] = "bash",
	},
	pattern = {
		["compose.*%.ya?ml"] = "yaml.docker-compose",
		["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
	},
	extension = {
		tmpl = "gotmpl",
		age = "age",
	},
})
--- }}}

require("options")
require("autocmds")
if vim.fn.has("win32") == 1 then require("windows") end
if vim.g.neovide then require("neovide") end
