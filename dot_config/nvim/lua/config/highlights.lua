-- Highlights
local hl = vim.api.nvim_create_augroup("highlights", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	group = hl,
	pattern = "*",
	callback = function()
		local set_hl = vim.api.nvim_set_hl
		set_hl(0, "LspSignatureActiveParameter", { italic = true, bold = true })
		set_hl(0, "SnacksPickerPathIgnored", { link = "Ignore" })
		set_hl(0, "SnacksPickerGitStatussdfIgnored", { link = "Ignore" })
		set_hl(0, "SniprunVirtualTextOk", { link = "Grey" })
		set_hl(0, "SniprunVirtualTextErr", { link = "Red" })
	end,
	desc = "Update custom highlight settings on colorscheme change for all colorschemes",
})

-- gruvbox-material
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("custom_highlights_gruvboxmaterial", {}),
	pattern = "gruvbox-material",
	callback = function()
		local config = vim.fn["gruvbox_material#get_configuration"]()
		local palette = vim.fn["gruvbox_material#get_palette"](config.background, config.foreground, config.colors_override)
		local set_hl = vim.fn["gruvbox_material#highlight"]

		set_hl("DiffText", palette.none, palette.bg_visual_red)
	end,
	desc = "Set custom highlights specific to gruvbox-material",
})
