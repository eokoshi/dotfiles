-- Title bar color
vim.g.neovide_title_background_color =
	string.format("%x", vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg)

vim.o.guifont = "Cascadia_Mono_NF:h10"
vim.g.neovide_title_text_color = "darkgrey"
vim.g.neovide_floating_shadow = false

if next(_G.arg) == nil then
	vim.cmd({ cmd = "cd", args = { vim.fn.expand("~") } })
end
