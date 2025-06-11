local M = {}

-- Toggle autosave for current buffer
function M.ToggleBufferAutoSave()
	local bufnr = vim.api.nvim_get_current_buf()
	local key = "autosave_enabled"

	-- Toggle the buffer-local variable
	local current = vim.b[key]
	if current then
		vim.b[key] = false
		vim.cmd("autocmd! AutoSaveBuffer" .. bufnr)
		vim.notify("AutoSave disabled for buffer " .. bufnr, vim.log.levels.INFO)
	else
		vim.b[key] = true
		local group = vim.api.nvim_create_augroup("AutoSaveBuffer" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
			group = group,
			buffer = bufnr,
			callback = function()
				if vim.b[key] and vim.bo.modifiable and vim.bo.modified then
					vim.cmd("silent write")
				end
			end,
		})
		vim.notify("AutoSave enabled for buffer " .. bufnr, vim.log.levels.INFO)
	end
end

vim.api.nvim_create_user_command("ToggleBufferAutoSave", M.ToggleBufferAutoSave, {})

-- convert dos fileformat to unix
function M.DOS_to_Unix()
	vim.bo.fileformat = "unix"
	vim.cmd("%s/\r//geI")
	vim.cmd("set ff?")
end

function M.notifications_picker()
	require("snacks").picker.notifications({
		layout = {
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
			input = {
				keys = {
					["<C-Space>"] = { "cycle_win", mode = { "i", "n" } },
				},
			},
			list = {
				keys = {
					["<C-Space>"] = { "cycle_win", mode = { "i", "n" } },
				},
			},
			preview = {
				keys = {
					["<C-Space>"] = { "cycle_win", mode = { "i", "n" } },
				},
			},
		},
		-- actions = {
		-- 	cycle_layouts = function(picker)
		-- 		local layout_config = vim.deepcopy(picker.resolved_layout)
		--
		-- 		if layout_config.preview == "main" or not picker.preview.win:valid() then
		-- 			return
		-- 		end
		--
		-- 		local function find_preview(root) ---@param root snacks.layout.Box|snacks.layout.Win
		-- 			if root.win == "preview" then
		-- 				return root
		-- 			end
		-- 			if #root then
		-- 				for _, w in ipairs(root) do
		-- 					local preview = find_preview(w)
		-- 					if preview then
		-- 						return preview
		-- 					end
		-- 				end
		-- 			end
		-- 			return nil
		-- 		end
		--
		-- 		local preview = find_preview(layout_config.layout)
		--
		-- 		if not preview then
		-- 			return
		-- 		end
		--
		-- 		local eval = function(s)
		-- 			return type(s) == "function" and s(preview.win) or s
		-- 		end
		-- 		--- @type number?, number?
		-- 		local width, height = eval(preview.width), eval(preview.height)
		--
		-- 		if not width and not height then
		-- 			return
		-- 		end
		--
		-- 		local cycle_sizes = { 0.1, 0.9 }
		-- 		local size_prop, size
		--
		-- 		if height then
		-- 			size_prop, size = "height", height
		-- 		else
		-- 			size_prop, size = "width", width
		-- 		end
		--
		-- 		picker.init_size = picker.init_size or size ---@diagnostic disable-line: inject-field
		-- 		table.insert(cycle_sizes, picker.init_size)
		-- 		table.sort(cycle_sizes)
		--
		-- 		for i, s in ipairs(cycle_sizes) do
		-- 			if size == s then
		-- 				local smaller = cycle_sizes[i - 1] or cycle_sizes[#cycle_sizes]
		-- 				preview[size_prop] = smaller
		-- 				break
		-- 			end
		-- 		end
		--
		-- 		for i, h in ipairs(layout_config.hidden) do
		-- 			if h == "preview" then
		-- 				table.remove(layout_config.hidden, i)
		-- 			end
		-- 		end
		--
		-- 		picker:set_layout(layout_config)
		-- 	end,
		-- },
	})
end

return M
