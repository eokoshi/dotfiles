---@type LazySpec
return {
  "mbbill/undotree",
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      opts.mappings.n["<leader>U"] = {
        function()
          vim.cmd.UndotreeToggle()
        end,
        desc = "Open undotree",
      }
    end,
  },
}
