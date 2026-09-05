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
	["nt"] = { name = "nt", hl = "StatuslineNormal" },
}

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

local function get_searchcount()
	if vim.v.hlsearch == 0 then return "" end
	local sc = vim.fn.searchcount()
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
	local mode_info = modes[mode_code] or { name = mode_code, hl = "StatuslineSection" }
	local mode_str = string.format("%%#%s# %s %%*", "StatuslineSection", mode_info.name)
	if is_active then mode_str = string.format("%%#%s# %s %%*", mode_info.hl, mode_info.name) end
	local macro = " %#RedBold#" .. get_macro() .. "%*"
	local searchcount = " %#AquaItalic#" .. get_searchcount() .. "%*"
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
		searchcount,
		diagnostics,
		lsp_formatter,
		filetype,
		encoding,
		lineending,
	})
end

vim.o.statusline = "%!v:lua.my_statusline()"
