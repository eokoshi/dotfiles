vim.cmd.colorscheme("gruvbox-material")

vim.api.nvim_create_augroup("highlights", {})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	pattern = "*",
	callback = function()
		-- vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "NONE", fg = "NONE" })
		vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { italic = true, bold = true })
		vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { link = "Ignore" })
		vim.api.nvim_set_hl(0, "SnacksPickerGitStatussdfIgnored", { link = "Ignore" })
		vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { link = "DiffAdd" })
		vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { link = "DiffChange" })
		vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { link = "DiffDelete" })
		vim.api.nvim_set_hl(0, "SniprunVirtualTextOk", { link = "Grey" })
		vim.api.nvim_set_hl(0, "SniprunVirtualTextErr", { link = "Red" })
	end,
})
