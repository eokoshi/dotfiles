-- Provide a command to create a blank new Python notebook
-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
-- if you use another language than Python, you should change it in the template.
local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

local function new_notebook(filename)
	local path = filename .. ".ipynb"
	local file = io.open(path, "w")
	if file then
		file:write(default_notebook)
		file:close()
		vim.cmd("edit " .. path)
	else
		vim.notify("Could not open new notebook file for writing", vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_user_command("NewNotebook", function(opts)
	new_notebook(opts.args)
end, {
	nargs = 1,
	complete = "file",
})

return {
	-- Converting ipynb json to markdown
	{
		"GCBallesteros/jupytext.nvim",
		opts = {
			style = "markdown",
			output_extension = "md",
			force_ft = "markdown",
		},
	},
	-- Code block highlighting and LSP activation
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
		},
		ft = { "markdown", "ipynb" },
		opts = {
			closePreviewOnExit = true,
			lspFeatures = {
				enabled = true,
				chunks = "all",
				completion = {
					enabled = true,
				},
			},
			codeRunner = {
				enabled = false,
			},
		},
	},
}
