return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"j-hui/fidget.nvim",
	},
	opts = {
		display = {
			chat = {
				start_in_insert_mode = true,
				show_settings = true,
			},
			action_palette = {
				opts = {
					show_default_adapters = false,
				},
			},
		},
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
					parameters = {
						sync = true,
					},
					schema = {
						model = {
							default = "hf.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF:Q6_K_L",
						},
						num_ctx = {
							default = 8192,
						},
					},
				})
			end,
			qwen3 = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "qwen3",
					env = {
						url = "http://100.113.130.46:11434",
					},
					headers = {
						["Content-Type"] = "application/json",
					},
					parameters = {
						sync = true,
					},
					schema = {
						model = {
							default = "qwen3:latest",
						},
						num_ctx = {
							default = 8192,
						},
					},
				})
			end,
			gemma3 = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "gemma3",
					env = {
						url = "http://100.113.130.46:11434",
					},
					headers = {
						["Content-Type"] = "application/json",
					},
					parameters = {
						sync = true,
					},
					schema = {
						model = {
							default = "gemma3:latest",
						},
						num_ctx = {
							default = 8192,
						},
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
