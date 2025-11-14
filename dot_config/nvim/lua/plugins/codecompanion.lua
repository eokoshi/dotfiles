return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
	opts = {
		display = {
			chat = {
				intro_message = "Chatbot time 󰭹 󰓠 󰚩   . Press ? for options",
				separator = "---",
				show_settings = true,
				start_in_insert_mode = false,
			},
			diff = {
				provider_opts = {
					split = {
						opts = { "filler", "closeoff", "algorithm:minimal", "followwrap", "linematch:120" },
					},
				},
			},
			action_palette = {
				provider = "default",
			},
		},
		strategies = {
			chat = {
				adapter = "llamacpp",
			},
			inline = {
				adapter = "llamacpp",
			},
			cmd = {
				adapter = "llamacpp",
			},
		},
		adapters = {
			http = {
				llamacpp = function()
					return require("codecompanion.adapters").extend("openai", {
						name = "llamacpp",
						url = "http://100.92.126.115:8000/v1/chat/completions",
						schema = {
							model = {
								default = "/models/gpt-oss-20b/gpt-oss-20b-mxfp4.gguf",
							},
						},
					})
				end,
				ollama_office = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "ollama_office",
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
								default = 16384,
							},
							keep_alive = {
								default = "60m",
							},
						},
					})
				end,
				tavily = function()
					return require("codecompanion.adapters").extend("tavily", {
						env = {
							api_key = "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",
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
