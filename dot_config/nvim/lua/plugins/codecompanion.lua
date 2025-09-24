return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
	version = "v14.13.0",
	init = function()
		local map = require("stuff.functions").map
		map({ "n", "x" }, "<Leader>a", "", { desc = "Chatbot" })
		map({ "n", "x" }, "<Leader>aa", "<CMD>CodeCompanionActions<CR>", { desc = "actions" })
		map({ "n", "x" }, "<Leader>at", "<CMD>CodeCompanionChat Toggle<CR>", { desc = "toggle chat window" })
		map({ "n", "x" }, "<Leader>ai", ":CodeCompanion ", { desc = "inline assist" })
		map("x", "ac", "<CMD>CodeCompanionChat Add<CR>", { desc = "add visual selection to chat" })
	end,
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
				opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
				provider = "default", -- default|mini_diff
			},
		},
		opts = {
			system_prompt = function()
				return [[/no_think
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Use '\n' only when you want a literal backslash followed by a character 'n'.
- Output the code in a single code block, being careful to only return relevant code.
- WHEN MODIFYING CODE TO SUGGEST CHANGES, GENERATE THE SMALLEST RELEVANT CODE BLOCK POSSIBLE, DO NOT OUTPUT THE ENTIRE SCRIPT
- WHEN REFERENCING CODE, DO NOT OUTPUT THE ENTIRE SECTION, RATHER PRINT THE FIRST FEW LINES, then ... on a new line, then the final few lines
- ANSWER CONCISELY, WITHOUT ADDING TOO MUCH BACKGROUND INFORMATION UNLESS THE USER REQUESTS IT
- GIVE MULTIPLE POSSIBLE SOLUTIONS TO THE ISSUE IF THE USER IS ASKING FOR TROUBLESHOOTING HELP
/no_think]]
			end,
		},
		strategies = {
			chat = {
				adapter = "qwen3",
				opts = {
					prompt_decorator = function(message, adapter, context)
						return string.format([[<prompt>%s</prompt>\no_think]], message)
					end,
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
							keep_alive = "60m",
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
							keep_alive = "60m",
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
							keep_alive = "60m",
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
							keep_alive = "60m",
						},
					},
				})
			end,
			opts = {
				show_defaults = false,
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
}
