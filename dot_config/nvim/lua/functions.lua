local M = {}

function M.gh(x) return "https://github.com/" .. x end

-- Set keymaps
function M.map(mode, lhs, rhs, opts)
	-- set default value if not specify
	if opts.noremap == "" then opts.noremap = true end
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

return M
