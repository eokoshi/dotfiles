local M = {}

-- Set keymaps
function M.map(mode, lhs, rhs, opts)
	-- set default value if not specify
	if opts.noremap == "" then
		opts.noremap = true
	end
	if opts.silent == "" then
		opts.silent = true
	end

	vim.keymap.set(mode, lhs, rhs, opts)
end

-- convert dos fileformat to unix
function M.DOS_to_Unix()
	vim.bo.fileformat = "unix"
	vim.cmd("%s/\r//geI")
	vim.cmd("set ff?")
end

return M
