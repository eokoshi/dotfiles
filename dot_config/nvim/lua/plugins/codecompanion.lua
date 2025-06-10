return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	version = "v14.13.0",
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
				provider = "mini_diff", -- default|mini_diff
			},
		},
		opts = {
			system_prompt = function()
				return [[\no_think
You are currently plugged in to the Neovim text editor on a user's machine.
Your core tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- Use actual line breaks instead of '\n' in your response to begin new lines.
- Use line breaks often so that the line length does not exceed 90 characters
- Use '\n' only when you want a literal backslash followed by a character 'n'.
- All non-code responses must be in English.

When given a task:
- Output the code in a single code block, being careful to only return relevant code.
- You can only give one reply for each conversation turn.
- WHEN MODIFYING CODE, ONLY REGENERATE THE RELEVANT SECTIONS, RATHER THAN REGENERATING THE ENTIRE SCRIPT
- WHEN REFERENCING CODE, DO NOT OUTPUT THE ENTIRE SECTION, RATHER PRINT THE FIRST FEW LINES, then ... on a new line, then the final few lines
- ANSWER CONCISELY, WITHOUT ADDING TOO MUCH BACKGROUND INFORMATION UNLESS THE USER REQUESTS IT
- GIVE MULTIPLE POSSIBLE SOLUTIONS TO THE ISSUE IF THE USER IS ASKING FOR TROUBLESHOOTING HELP
\no_think]]
			end,
		},
		strategies = {
			chat = {
				adapter = "qwen3",
				opts = {
					prompt_decorator = function(message, adapter, context)
						return string.format([[<prompt>%s</prompt>\no_think]], message)
					end,
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
							default = 16384,
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
