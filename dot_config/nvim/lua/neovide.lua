if vim.g.neovide then
	local hr = tonumber(os.date("%H", os.time()))
	if hr > 6 and hr < 21 then -- day between 6am and 9pm
		vim.cmd.colorscheme("onelight")
	else -- night
		vim.cmd.colorscheme("techbase")
	end

	-- Title bar color
	vim.g.neovide_title_background_color = string.format("%x", vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg)

	vim.o.guifont = "Cascadia Mono NF,DejaVuSansM Nerd Font Mono,UD Digi Kyokasho N:h10"
	vim.g.neovide_title_text_color = "darkgrey"
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_floating_shadow = false
	vim.o.swapfile = false

	if next(_G.arg) == nil then vim.cmd({ cmd = "cd", args = { vim.fn.expand("~") } }) end

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
end
