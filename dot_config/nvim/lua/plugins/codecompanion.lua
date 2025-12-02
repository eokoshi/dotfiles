return {
	"olimorris/codecompanion.nvim",
	version = "17.33.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
	opts = {
		display = {
			chat = {
				intro_message = "Chatbot time 󰭹 󰓠 󰚩   . Press ? for options",
				separator = "---",
				-- show_settings = true,
				start_in_insert_mode = false,
				icons = {
					buffer_watch = " ",
				},
				window = {
					layout = "horizontal",
					height = 0.45,
				},
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
				adapter = "gptoss120b_ol_df2",
				variables = {
					["buffer"] = {
						opts = {
							default_params = "watch",
						},
					},
				},
				tools = {
					opts = {
						auto_submit_errors = true,
						auto_submit_success = true,
						default_tools = {
							"file_search",
							"grep_search",
							"web_search",
							"read_file",
						},
					},
				},
			},
			inline = {
				adapter = "qwen3vl_ol_df2",
			},
			cmd = {
				adapter = "gptoss120b_ol_df2",
			},
		},
		adapters = {
			http = {
				opts = {
					show_defaults = false,
				},
				gptoss120b_ol_df2 = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "gptoss120b_ol_df2",
						env = {
							url = "http://100.106.205.69:11434",
						},
						headers = {
							["Content-Type"] = "application/json",
						},
						schema = {
							model = {
								default = "gpt-oss:120b",
							},
							keep_alive = {
								default = "15m",
							},
						},
					})
				end,
				qwen3vl_ol_df2 = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "qwen3vl_ol_df2",
						env = {
							url = "http://100.106.205.69:11434",
						},
						headers = {
							["Content-Type"] = "application/json",
						},
						schema = {
							model = {
								default = "qwen3-vl:32b",
							},
							keep_alive = {
								default = "15m",
							},
						},
					})
				end,
				gptoss120b_lc_df2 = function()
					return require("codecompanion.adapters").extend("openai", {
						name = "llamacpp",
						url = "http://100.106.205.69:8000/v1/chat/completions",
						schema = {
							model = {
								default = "/models/gpt-oss-120b/gpt-oss-120b-mxfp4-00001-of-00003.gguf",
							},
						},
					})
				end,
				gptoss20b_lc_bs = function()
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
				qwen3_ol_office = function()
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
			acp = {
				opts = {
					show_defaults = false,
				},
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
		map("x", "<Leader>ac", "<CMD>CodeCompanionChat Add<CR>", { desc = "add visual selection to chat" })
	end,
}
