return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
	-- version = "v14.13.0",
	opts = {
		display = {
			chat = {
				window = {
					layout = "horizontal",
					position = "bottom",
					height = 0.4,
				},
				intro_message = "Chatbot time 󰭹 󰓠 󰚩   . Press ? for options",
				separator = "---",
				show_settings = true,
				start_in_insert_mode = false,
			},
			diff = {
				enabled = true,
				close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
				layout = "vertical", -- vertical|horizontal split for default provider
				opts = { "filler", "closeoff", "algorithm:minimal", "followwrap", "linematch:120" },
				provider = "default", -- default|mini_diff
			},
			action_palette = {
				provider = "default",
			},
		},
		strategies = {
			chat = {
				adapter = "qwen3",
				opts = {
					completion_provider = "blink",
				},
			},
			inline = {
				adapter = "qwen3",
			},
			cmd = {
				adapter = "qwen3",
			},
		},
		adapters = {
			http = {
				deepseek = function()
					return require("codecompanion.adapters").extend("ollama", {
						env = {
							url = "http://100.113.130.46:11434",
						},
						headers = {
							["Content-Type"] = "application/json",
						},
						schema = {
							model = {
								default = "deepseek-r1:latest",
							},
							num_ctx = {
								default = 16384,
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
						schema = {
							model = {
								default = "qwen3:latest",
							},
							num_ctx = {
								default = 40000,
							},
							keep_alive = {
								default = "60m",
							},
							think = {
								default = false,
							},
						},
					})
				end,
				qwen_coder = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "qwen3",
						env = {
							url = "http://100.113.130.46:11434",
						},
						headers = {
							["Content-Type"] = "application/json",
						},
						schema = {
							model = {
								default = "hf.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF:Q6_K_L",
							},
							num_ctx = {
								default = 16384,
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
						schema = {
							model = {
								default = "gemma3:latest",
							},
							num_ctx = {
								default = 32768,
							},
						},
					})
				end,
			},
		},
	},
	send = {
		callback = function(chat)
			vim.cmd("stopinsert")
			chat:add_buf_message({ role = "llm", content = "" })
			chat:submit()
		end,
		index = 1,
		description = "Send",
	},
	init = function()
		local map = require("stuff.functions").map
		map({ "n", "x" }, "<Leader>a", "", { desc = "Chatbot" })
		map({ "n", "x" }, "<Leader>aa", "<CMD>CodeCompanionActions<CR>", { desc = "actions" })
		map({ "n", "x" }, "<Leader>at", "<CMD>CodeCompanionChat Toggle<CR>", { desc = "toggle chat window" })
		map({ "n", "x" }, "<Leader>ai", ":CodeCompanion ", { desc = "inline assist" })
		map("x", "ac", "<CMD>CodeCompanionChat Add<CR>", { desc = "add visual selection to chat" })
	end,
}
