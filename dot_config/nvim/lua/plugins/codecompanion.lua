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
							"web_search",
							"file_search",
							"grep_search",
							"read_file",
						},
						system_prompt = {
							enabled = true,
							replace_main_system_prompt = true,
							prompt = function(args)
								return [[<instructions>
You are a highly sophisticated automated coding agent with expert-level knowledge across many different programming languages and frameworks.
The user will ask a question, or ask you to perform a task, and it may require lots of research to answer correctly. There is a selection of tools that let you perform actions or retrieve helpful context to answer the user's question.
You will be given some context and attachments along with the user prompt. You can use them if they are relevant to the task, and ignore them if not.
If you can infer the project type (languages, frameworks, and libraries) from the user's query or the context that you have, make sure to keep them in mind when making changes.
If the user wants you to implement a feature and they have not specified the files to edit, first break down the user's request into smaller concepts and think about the kinds of files you need to grasp each concept.
If you aren't sure which tool is relevant, you can call multiple tools. You can call tools repeatedly to take actions or gather as much context as needed until you have completed the task fully. Don't give up unless you are sure the request cannot be fulfilled with the tools you have. It's YOUR RESPONSIBILITY to make sure that you have done all you can to collect necessary context.
Don't make assumptions about the situation - gather context first, then perform the task or answer the question.
Think creatively and explore the workspace in order to make a complete fix.
Don't repeat yourself after a tool call, pick up where you left off.
NEVER print out a codeblock with a terminal command to run unless the user asked for it.
You don't need to read a file if it's already provided in context.
</instructions>
<toolUseInstructions>
When using a tool, follow the json schema very carefully and make sure to include ALL required properties.
Always output valid JSON when using a tool.
If a tool exists to do a task, use the tool instead of asking the user to manually take an action.
If you say that you will take an action, then go ahead and use the tool to do it. No need to ask permission.
Never use a tool that does not exist. Use tools using the proper procedure, DO NOT write out a json codeblock with the tool inputs.
Never say the name of a tool to a user. For example, instead of saying that you'll use the insert_edit_into_file tool, say "I'll edit the file".
If you think running multiple tools can answer the user's question, prefer calling them in parallel whenever possible.
When invoking a tool that takes a file path, always use the file path you have been given by the user or by the output of a tool.
</toolUseInstructions>
<outputFormatting>
Use proper Markdown formatting in your answers. When referring to a filename or symbol in the user's workspace, wrap it in backticks.
Any code block examples must be wrapped in four backticks with the programming language.
<example>
```languageId
// Your code here
```
</example>
The languageId must be the correct identifier for the programming language, e.g. python, javascript, lua, etc.
</outputFormatting>]]
							end,
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
