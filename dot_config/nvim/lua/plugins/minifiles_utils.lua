local MiniFiles = require("mini.files")
local nsMiniFiles = vim.api.nvim_create_namespace("mini_files_git")

local M = {}

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
		local escapedcwd = cwd and vim.pesc(cwd) ---@type string
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
					if not line then return end
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
		if not filePath then return {} end
		if status == "R " then filePath = string.match(filePath, "^.*%s%-%>%s(.*)") end
		if not filePath then return {} end
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

function M.minifiles_toggle(...)
	if not MiniFiles.close() then MiniFiles.open(...) end
end

function M.yank_path()
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

function M.set_cwd()
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

function M.toggle_preview()
	local preview = MiniFiles.config.windows.preview
	local preview_next = not preview
	local right_edge = vim.api.nvim_win_get_width(0) + vim.api.nvim_win_get_position(0)[2]
	local preview_width = math.min(150, math.ceil((vim.o.columns - right_edge) * 0.9))
	MiniFiles.config.windows.preview = preview_next
	MiniFiles.trim_right()
	MiniFiles.refresh({ windows = { preview = preview_next, width_preview = preview_width } })
	if preview then
		local state = MiniFiles.get_explorer_state()
		if not state then return 1 end
		local branch = state.branch
		table.remove(branch)
		pcall(function()
			MiniFiles.set_branch(branch)
			return 0
		end)
	end
end

return M
