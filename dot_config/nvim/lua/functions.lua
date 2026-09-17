local M = {}

function M.gh(x) return "https://github.com/" .. x end

-- Set keymaps
function M.map(mode, lhs, rhs, opts)
	-- set default value if not specify
	if opts.silent == "" then opts.silent = true end

	vim.keymap.set(mode, lhs, rhs, opts)
end

-- convert dos fileformat to unix
function M.DOS_to_Unix()
	vim.cmd("%s/\r//geI")
	vim.cmd("set ff?")
	vim.bo.fileformat = "unix"
end

---@param f function
---@return nil
function M.safely(f)
	local success, status = pcall(f)
	if success == false then vim.notify(status, vim.log.levels.ERROR) end
end

function M.keywordprg()
	local cword = vim.fn.expand("<cword>")
	local prg = vim.bo.keywordprg
	if prg == "" then
		vim.cmd("help!")
	elseif prg:sub(1, 1) == ":" then
		vim.cmd(prg:sub(2) .. " " .. cword)
	else
		vim.cmd("!" .. prg .. " " .. cword)
	end
end

---@param dir_path string
function M.open_daily_note(dir_path)
	if not vim.uv.fs_stat(dir_path) then
		vim.notify("Daily Notes directory not found", vim.log.levels.WARN)
		return
	end

	local date_str = os.date("%Y-%m-%d")
	local file_path = dir_path .. "/" .. date_str .. ".md"
	if not vim.uv.fs_stat(file_path) then
		local template = string.format("# %s\n\n## To Do\n\n## What I Did Today\n\n## Notes\n", date_str)
		local new_file = io.open(file_path, "w")
		if new_file then
			new_file:write(template)
			new_file:close()
		else
			vim.notify("Failed to create daily note file", vim.log.levels.ERROR)
			return
		end
	end

	vim.cmd("edit " .. vim.fn.fnameescape(file_path))
end

---@param dir_path string
function M.open_previous_daily_note(dir_path)
	if not vim.uv.fs_stat(dir_path) then
		vim.notify("Daily Notes directory not found", vim.log.levels.WARN)
		return
	end

	local today_str = os.date("%Y-%m-%d")

	local files = {}
	for name in vim.fs.dir(dir_path) do
		-- Match YYYY-MM-DD.md format and collect dates strictly earlier than today
		local date_str = name:match("^(%d%d%d%d%-%d%d%-%d%d)%.md$")
		if date_str and date_str < today_str then table.insert(files, date_str) end
	end

	if #files == 0 then
		vim.notify("No previous daily notes found", vim.log.levels.INFO)
		return
	end

	table.sort(files, function(a, b) return a > b end)
	local most_recent_file = dir_path .. "/" .. files[1] .. ".md"
	vim.cmd("edit " .. vim.fn.fnameescape(most_recent_file))
end

return M
