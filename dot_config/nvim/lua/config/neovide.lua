vim.cmd("colorscheme astrolight")

vim.g.neovide_title_background_color = string.format("%x", vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg)
vim.g.neovide_title_text_color = "darkgrey"
vim.g.neovide_window_blurred = false
vim.g.neovide_opacity = 1

vim.api.nvim_set_hl(0, "TabLineFill", { link = "Normal" })
-- vim.o.guifont = "Cascadia_Mono_NF,DejaVuSansM_Nerd_Font_Mono,UD_Digi_Kyokasho_N:h10"
