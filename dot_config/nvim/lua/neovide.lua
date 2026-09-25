vim.o.guifont = "Cascadia Mono NF,BIZ UDGothic:h10"
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_floating_shadow = false
vim.g.neovide_remember_window_size = false

vim.o.winblend = 15

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta) vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta end
vim.keymap.set("n", "<C-;>", function() change_scale_factor(1.25) end)
vim.keymap.set("n", "<C-->", function() change_scale_factor(1 / 1.25) end)
vim.keymap.set("n", "<C-0>", function() vim.g.neovide_scale_factor = 1 end)

local config_path
if vim.fn.has("wsl") == 1 then
	config_path = vim.fs.normalize("~/windows/AppData/Roaming/neovide/config.toml")
elseif vim.fn.has("win32") == 1 then
	config_path = vim.fs.normalize("~/AppData/Roaming/neovide/config.toml")
else
	config_path = vim.fs.normalize("~/.config/neovide/config.toml")
end
vim.keymap.set("n", "<Leader>pn", function() vim.cmd("edit " .. config_path) end, { desc = "Neovide Config" })

local neovide_augroup = vim.api.nvim_create_augroup("neovide", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = neovide_augroup,
	pattern = "*",
	callback = function()
		local function hl(name) return vim.api.nvim_get_hl(0, { name = name }) end
		local fg = hl("Comment").fg or hl("Comment").guifg
		local bg = hl("Normal").bg or hl("Normal").guibg

		vim.g.neovide_title_text_color = string.format("%.6x", fg)
		vim.g.neovide_title_background_color = string.format("%.6x", bg)
	end,
})

local hr = tonumber(os.date("%H", os.time()))
if hr > 6 and hr < 18 then -- day between 6am and 6pm
	vim.cmd("colorscheme onelight")
else -- night
	vim.cmd("colorscheme entryway")
end

--- IME stuff
local function set_ime(args)
	if args.event:match("Enter$") then
		vim.g.neovide_input_ime = true
	else
		vim.g.neovide_input_ime = false
	end
end
local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })
vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
	group = ime_input,
	pattern = "*",
	callback = set_ime,
})
vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
	group = ime_input,
	pattern = "[/\\?]",
	callback = set_ime,
})

-- what do to when opened without a specific file
if vim.fn.argc() == 0 then
	vim.cmd({ cmd = "cd", args = { vim.fn.expand("~/Documents/Obsidian") } })
else
	vim.cmd("cd %:h")
	vim.notify(vim.fn.getcwd())
end
