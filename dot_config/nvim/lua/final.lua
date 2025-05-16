-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "NONE", fg = "NONE" })
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { italic = true, bold = true })
