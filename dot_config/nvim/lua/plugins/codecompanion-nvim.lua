return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"j-hui/fidget.nvim",
	},
	opts = {
		strategies = {
			chat = {
				adapter = "ollama",
			},
			inline = {
				adapter = "ollama",
			},
			cmd = {
				adapter = "ollama",
			},
		},
		adapters = {
			ollama = function()
				return require("codecompanion.adapters").extend("ollama", {
					env = {
						url = "http://100.113.130.46:11434",
					},
					headers = {
						["Content-Type"] = "application/json",
					},
				})
			end,
		},
	},
	init = function()
		require("plugins.codecompanion.inline-spinner"):init()
	end,
	send = {
		callback = function(chat)
			vim.cmd("stopinsert")
			chat:add_buf_message({ role = "llm", content = "" })
			chat:submit()
		end,
		index = 1,
		description = "Send",
	},
}
