vim.opt.shelltemp = false
vim.opt.shell = "pwsh"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
	.. "[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();"
	.. "$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
	.. "$PSStyle.OutputRendering = 'PlainText';"
vim.opt.shellpipe = "> %s 2>&1"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
vim.env.__SuppressAnsiEscapeSequences = 1

if vim.g.neovide then
	-- Title bar color
	vim.cmd.colorscheme("onelight")
	vim.g.neovide_title_background_color = string.format("%x", vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg)

	vim.o.guifont = "Cascadia_Mono_NF:h10"
	vim.g.neovide_title_text_color = "darkgrey"
	vim.g.neovide_floating_shadow = false
	vim.o.swapfile = false
	vim.o.winborder = "none"

	if next(_G.arg) == nil then vim.cmd({ cmd = "cd", args = { vim.fn.expand("~") } }) end
end

vim.opt.cmdheight = 0
require("vim._core.ui2").enable({
	enable = true, -- Whether to enable or disable the UI.
	msg = { -- Options related to the message module.
		---@type 'cmd'|'msg' Default message target, either in the
		---cmdline or in a separate ephemeral message window.
		---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
		---or table mapping |ui-messages| kinds and triggers to a target.
		targets = "msg",
		cmd = { -- Options related to messages in the cmdline window.
			height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
		},
		dialog = { -- Options related to dialog window.
			height = 0.5, -- Maximum height.
		},
		msg = { -- Options related to msg window.
			height = 0.5, -- Maximum height.
			timeout = 4000, -- Time a message is visible in the message window.
		},
		pager = { -- Options related to message window.
			height = 1, -- Maximum height.
		},
	},
})
