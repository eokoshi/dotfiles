return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.icons",
      "AstroNvim/astrotheme",
    }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  --- change colorscheme to more header-friendly colors
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        ft_colorschemes = {
          -- Save the current colorscheme when entering a markdown file
          {
            event = { "BufEnter", "BufWinEnter" },
            desc = "Temporarily change colorscheme for Markdown",
            pattern = "*.md",
            callback = function()
              -- Save the current colorscheme *only if it hasn't been saved already*
              if vim.g._previous_colorscheme == nil then vim.g._previous_colorscheme = vim.g.colors_name end
              vim.cmd "colorscheme astrodark"
            end,
          },
          {
            event = { "BufLeave", "BufWinLeave" },
            desc = "Restore previous colorscheme after leaving Markdown",
            pattern = "*.md",
            callback = function()
              if vim.g._previous_colorscheme then
                vim.cmd("colorscheme " .. vim.g._previous_colorscheme)
                vim.g._previous_colorscheme = nil
              end
            end,
          },
        },
      },
    },
  },
}
