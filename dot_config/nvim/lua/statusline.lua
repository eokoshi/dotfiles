-- vim.api.nvim_create_autocmd({ "ModeChanged" }, {
-- 	group = vim.api.nvim_create_augroup("statusline", { clear = true }),
-- 	callback = function() vim.cmd("redrawstatus") end,
-- })
local function get_macro()
	local reg = vim.fn.reg_recording()
	if reg == "" then return "" end
	return "recording @" .. reg
end

local function get_filesize(bufnr)
	local file = vim.api.nvim_buf_get_name(bufnr)
	if file == "" or #file == 0 then return "" end
	local size = vim.fn.getfsize(file) ---@type number
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
	local text = vim.diagnostic.status(bufnr)
	return text:gsub(":", " ")
end

local function get_searchcount()
	if vim.v.hlsearch == 0 then return "" end
	local sc = vim.fn.searchcount()
	if sc.current == nil or sc.total == nil then return "" end
	return "[" .. sc.current .. "/" .. sc.total .. "]"
end

local function get_truncated_filename(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then return "[No Name]" end
	local rel_path = vim.fn.fnamemodify(name, ":~:.")
	if #rel_path > 40 then rel_path = vim.fn.pathshorten(rel_path, 3) end
	return rel_path
end

local function get_lsp_formatter(bufnr)
	local out = ""
	if #vim.lsp.get_clients({ bufnr = bufnr }) > 0 then out = out .. " " end
	local success, conform = pcall(require, "conform")
	if success == false then return "" end
	if conform and #conform.list_formatters_for_buffer(bufnr) > 0 then out = out .. "󰉼" end
	return out
end

local function set_statusline_highlights()
	-- local fg = vim.api.nvim_get_hl(0, { name = "WinSeparator" }).fg
	local fg = "NvimDarkGrey1"
	vim.api.nvim_set_hl(0, "User1", { fg = fg, bg = "#a6e3a1" })
	vim.api.nvim_set_hl(0, "User2", { fg = fg, bg = "#ffe97a" })
	vim.api.nvim_set_hl(0, "User3", { fg = fg, bg = "#89b4fa" })
	vim.api.nvim_set_hl(0, "User4", { fg = fg, bg = "#f38ba8" })
	vim.api.nvim_set_hl(0, "User5", { fg = fg, bg = "#cba6f7" })
	vim.api.nvim_set_hl(0, "User6", { fg = fg, bg = "#94e2d5" })
	vim.api.nvim_set_hl(0, "User7", { fg = fg, bg = "#ecae67" })
	vim.api.nvim_set_hl(0, "User8", { fg = fg, bg = "#ffa8a8" })
	vim.api.nvim_set_hl(0, "User9", { fg = fg, bg = "#0d7d61" })
end
local modes = {
	["n"] = { name = "n", hl = "User3" },
	["no"] = { name = "no", hl = "User9" },
	["nov"] = { name = "nov", hl = "User9" },
	["noV"] = { name = "noV", hl = "User9" },
	["no\22"] = { name = "no^V", hl = "User9" },
	["niI"] = { name = "niI", hl = "User9" },
	["niR"] = { name = "niR", hl = "User9" },
	["niV"] = { name = "niV", hl = "User9" },
	["nt"] = { name = "nt", hl = "User6" },
	["ntT"] = { name = "ntT", hl = "User9" },
	["v"] = { name = "v", hl = "User2" },
	["vs"] = { name = "vs", hl = "User2" },
	["V"] = { name = "V", hl = "User2" },
	["Vs"] = { name = "Vs", hl = "User2" },
	["\22"] = { name = "^V", hl = "User2" },
	["\22s"] = { name = "^Vs", hl = "User2" },
	["s"] = { name = "s", hl = "User2" },
	["S"] = { name = "S", hl = "User2" },
	["\19"] = { name = "^S", hl = "User2" },
	["i"] = { name = "i", hl = "User1" },
	["ic"] = { name = "ic", hl = "User1" },
	["ix"] = { name = "ic", hl = "User7" },
	["R"] = { name = "R", hl = "User4" },
	["Rv"] = { name = "Rv", hl = "User4" },
	["Rvc"] = { name = "Rvc", hl = "User4" },
	["Rvx"] = { name = "Rvx", hl = "User7" },
	["Rx"] = { name = "Rx", hl = "User7" },
	["c"] = { name = "c", hl = "User5" },
	["cv"] = { name = "cv", hl = "User5" },
	["cr"] = { name = "cr", hl = "User5" },
	["cvr"] = { name = "cvr", hl = "User5" },
	["r"] = { name = "r", hl = "User8" },
	["rm"] = { name = "rm", hl = "User8" },
	["r?"] = { name = "r?", hl = "User8" },
	["!"] = { name = "!", hl = "User9" },
	["t"] = { name = "t", hl = "User1" },
}

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_statusline_highlights,
})

function _G.my_statusline()
	local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	local bufnr = vim.api.nvim_win_get_buf(winid)
	local is_active = (winid == vim.api.nvim_get_current_win())
	local mode_code = vim.api.nvim_get_mode().mode
	local mode_info = modes[mode_code] or { name = mode_code, hl = "Error" }
	local mode_str = string.format("%%#%s# %s %%*", "StatusLineNC", mode_info.name)
	if is_active then mode_str = string.format("%%#%s# %s %%*", mode_info.hl, mode_info.name) end
	local filename = "%#Number#" .. get_truncated_filename(bufnr)
	local bufargs = "%#NonText#%m%r%*"
	local buf = "%#Operator#" .. bufnr
	local filesize = "%#Type#" .. (get_filesize(bufnr) or "0B")
	local location = "%#Identifier#%l:%c %p%%"
	local macro = "%#Macro#" .. get_macro()
	local showcmd = "%#NonText#%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}"
	local progress =
		"%{% luaeval('(package.loaded[''vim.ui''] and vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or -1) and vim.ui.progress_status()) or '''' ')%}"
	local searchcount = "%#Comment#" .. get_searchcount()
	local diagnostics = get_diagnostics(bufnr)
	local lsp_formatter = "%#Identifier#" .. get_lsp_formatter(bufnr)
	local filetype = "%#Constant#" .. (vim.bo[bufnr].filetype ~= "" and vim.bo[bufnr].filetype or "")
	local encoding = "%#Conditional#" .. (vim.bo[bufnr].fileencoding ~= "" and vim.bo[bufnr].fileencoding or vim.o.encoding)
	local lineending = "%#Number#" .. (vim.bo[bufnr].fileformat:upper() == "UNIX" and "" or (vim.bo[bufnr].fileformat:upper() == "DOS" and ""))
	return table.concat({
		mode_str,
		filename,
		bufargs,
		buf,
		filesize,
		location,
		macro,
		"%=", -- Alignment separator (pushes following items to the right)
		searchcount,
		diagnostics,
		lsp_formatter,
		filetype,
		encoding,
		lineending,
	}, " ")
end
local default = [[
%<%f %h%w%m%r 
%{% v:lua.require('vim._core.util').term_exitcode() %}
%=
%{% luaeval('(package.loaded[''vim.ui''] and vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or -1) and vim.ui.progress_status()) or '''' ')%}
%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}
%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}
%{% &busy > 0 ? '◐ ' : '' %}
%{% luaeval('(package.loaded[''vim.diagnostic''] and next(vim.diagnostic.count()) and vim.diagnostic.status() .. '' '') or '''' ') %}%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}
]]
vim.o.showcmdloc = "statusline"
vim.o.statusline = "%!v:lua.my_statusline()"
