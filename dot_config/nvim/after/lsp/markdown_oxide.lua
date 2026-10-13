---@type vim.lsp.Config
return {
	on_init = function(client)
		local file_ops = vim.tbl_get(client.server_capabilities, "workspace", "fileOperations")
		if type(file_ops) ~= "table" then return end
		for _, reg in pairs(file_ops) do
			for _, filter in ipairs(type(reg) == "table" and reg.filters or {}) do
				if filter.scheme == vim.NIL then filter.scheme = nil end
			end
		end
	end,
}
