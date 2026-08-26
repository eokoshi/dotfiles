vim.o.guifont = "0xProto Nerd Font Mono,UD Digi Kyokasho N:h10"
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_floating_shadow = false
vim.g.neovide_remember_window_size = false

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
if hr > 6 and hr < 21 then -- day between 6am and 9pm
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
