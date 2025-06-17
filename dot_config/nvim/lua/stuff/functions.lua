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

return M
