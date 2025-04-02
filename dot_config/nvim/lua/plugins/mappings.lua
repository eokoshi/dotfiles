-- mappings.lua

return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- normal mode
        n = {
          ["<C-u>"] = { "<C-u>zz", desc = "Go up half page" },
          ["<C-d>"] = { "<C-d>zz", desc = "Go down half page" },
          ["<C-o>"] = { "<C-o>zz", desc = "Go to next jump " },
          ["<C-i>"] = { "<C-i>zz", desc = "Go to previous jump" },
          ["<leader>dfo"] = { ":diffget<CR>", silent = true, desc = "diffget" },
          ["<leader>dfp"] = { ":diffput<CR>", silent = true, desc = "diffput" },
          ["\\"] = false,
          ["<leader>dw"] = {
            function() require("dapui").elements.watches.add() end,
            silent = true,
            desc = "Watch Object",
          },
          ["<leader>dl"] = {
            ":e .vscode/launch.json<CR>",
            silent = true,
            desc = "Open workspace debug config",
          },
          ["<leader>im"] = { "/import<CR>", silent = true, desc = "Jump to imports" },
          ["<C-c>"] = { '"+yy', silent = true, desc = "Copy line to system clipboard" },
          ["<leader>t<CR>"] = {
            ":ToggleTermSendCurrentLine<CR>",
            desc = "Send current line to terminal",
            silent = true,
          },
          ["<leader>tp"] = {
            function()
              local ipyterm = require("toggleterm.terminal").Terminal:new {
                cmd = "uv run ipython",
                hidden = true,
              }
              ipyterm:toggle()
            end,
            noremap = true,
            silent = true,
            desc = "ToggleTerm ipython",
          },
          ["<leader>ts"] = { ":TermSelect<CR>", silent = true, noremap = true, desc = "TermSelect" },
          ["<leader>tb"] = {
            "Vgg:ToggleTermSendVisualSelection<CR><C-o>",
            silent = true,
            noremap = true,
            desc = "Send file up to this line to terminal",
          },
        },
        v = {
          ["<leader>dfo"] = { ":'<,'>diffget<CR>", silent = true },
          ["<leader>dfp"] = { ":'<,'>diffput<CR>", silent = true },
          ["<C-c>"] = { '"+y', silent = true, desc = "Copy to system clipboard" },
          ["<C-V"] = { "<C-v>", noremap = true },
          ["<leader>t<CR>"] = {
            ":ToggleTermSendVisualSelection<CR>",
            desc = "Send visual selection to terminal",
            silent = true,
          },
        },
        t = {
          ["<C-w><C-w>"] = { "<C-\\><C-n>", desc = "Go to normal mode in terminal" },
        },
        i = {
          ["<S-Tab>"] = { "<C-d>" },
        },
      },
    },
  },
}
