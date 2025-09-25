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

-- Toggle autosave for current buffer
function M.ToggleBufferAutoSave()
	local bufnr = vim.api.nvim_get_current_buf()
	local key = "autosave_enabled"

	-- Toggle the buffer-local variable
	local current = vim.b[key]
	if current then
		vim.b[key] = false
		vim.cmd("autocmd! AutoSaveBuffer" .. bufnr)
		-- vim.notify("AutoSave disabled for buffer " .. bufnr, vim.log.levels.INFO)
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
		-- vim.notify("AutoSave enabled for buffer " .. bufnr, vim.log.levels.INFO)
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
		confirm = { "yank", "close" },
		focus = "list",
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
	})
end

function M.pick_chezmoi()
	Snacks.picker.files({
		hidden = true,
		ignored = true,
		follow = true,
		dirs = {
			os.getenv("HOME") .. "/.local/share/chezmoi",
		},
	})
end

function M.pick_icons()
	---@diagnostic disable-next-line: missing-parameter
	local snacks_data = require("snacks.picker.source.icons").icons({})

	local file = vim.fn.stdpath("config") .. "/unicode_chars.json"
	local fd = assert(io.open(file, "r"))
	local data = fd:read("*a")
	fd:close()
	data = vim.json.decode(data)

	local result = {} ---@type snacks.picker.Icon[]
	for desc, info in pairs(data) do
		table.insert(result, {
			category = info.code,
			icon = info.char,
			name = desc,
			source = "unicode",
		})
	end
	for _, icon in ipairs(result) do
		icon.text = Snacks.picker.util.text(icon, { "source", "category", "name" })
		icon.data = icon.icon
	end
	---@diagnostic disable-next-line: param-type-mismatch
	for _, v in ipairs(snacks_data) do
		table.insert(result, v)
	end
	Snacks.picker.pick({
		items = result,
		layout = { preset = "vscode" },
		confirm = "put",
		format = "icon",
	})
end

return M
