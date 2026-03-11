return {
	{
		"yetone/avante.nvim",
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		-- ⚠️ must add this setting! ! !
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = {
			-- add any opts here
			-- this file can contain specific instructions for your project
			instructions_file = "avante.md",
			-- for example
			provider = "openrouter",
			providers = {
				openrouter = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					model = "z-ai/glm-4.5-air:free",
				},
			},
			selector = {
				--- @alias avante.SelectorProvider "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope" | fun(selector: avante.ui.Selector): nil
				--- @type avante.SelectorProvider
				provider = "snacks",
				-- Options override for custom providers
				provider_opts = {},
			},
			input = {
				provider = "snacks",
				provider_opts = {
					-- Additional snacks.input options
					title = "Avante Input",
					icon = " ",
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"folke/snacks.nvim", -- for input provider snacks
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
	{},
}
