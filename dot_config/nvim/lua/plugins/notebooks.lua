return {
	-- Converting ipynb json to markdown
	{
		"goerz/jupytext.nvim",
		opts = {
			format = "py:percent",
			async_write = true,
		},
	},
	-- -- Code block highlighting and LSP activation
	-- {
	-- 	"quarto-dev/quarto-nvim",
	-- 	dependencies = {
	-- 		"jmbuhr/otter.nvim",
	-- 	},
	-- 	ft = { "markdown", "ipynb" },
	-- 	opts = {
	-- 		closePreviewOnExit = true,
	-- 		lspFeatures = {
	-- 			enabled = true,
	-- 			chunks = "all",
	-- 			completion = {
	-- 				enabled = true,
	-- 			},
	-- 		},
	-- 		codeRunner = {
	-- 			enabled = false,
	-- 		},
	-- 	},
	-- },
}
