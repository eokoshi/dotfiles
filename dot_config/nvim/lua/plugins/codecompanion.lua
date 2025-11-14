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
				adapter = "gptoss",
				opts = {
					completion_provider = "blink",
				},
			},
			inline = {
				adapter = "gptoss",
			},
			cmd = {
				adapter = "gptoss",
			},
		},
		adapters = {
			http = {
				gptoss = function()
					return require("codecompanion.adapters").extend("openai", {
						name = "gptoss",
						url = "http://100.92.126.115:8000/v1/chat/completions",
						schema = {
							model = {
								default = "/models/gpt-oss-20b/gpt-oss-20b-mxfp4.gguf",
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
