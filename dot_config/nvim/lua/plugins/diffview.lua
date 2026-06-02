return {
	"sindrets/diffview.nvim",
	keys = {
		{ "<Leader>gD", mode = { "n" }, "<CMD>DiffviewOpen<CR>", desc = "Diff repo" },
		{ "<Leader>gh", mode = { "n" }, "<CMD>DiffviewFileHistory %<CR>", desc = "History: file" },
		{ "<Leader>gH", mode = { "n" }, "<CMD>DiffviewFileHistory<CR>", desc = "History: repo" },
	},
	config = function()
		local actions = require("diffview.actions")
		require("diffview").setup({
			enhanced_diff_hl = true,
			view = {
				default = {
					disable_diagnostics = true,
					winbar_info = true,
				},
				merge_tool = {
					layout = "diff3_mixed",
				},
			},
			file_panel = {
				win_config = {
					position = "bottom",
					height = 10,
				},
			},
			file_history_panel = {
				win_config = {
					type = "split",
					position = "bottom",
					height = 10,
				},
			},
			keymaps = {
				disable_defaults = true,
				view = {
					{ "n", "<Leader>q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
					{ "n", "<Leader>e", actions.toggle_files, { desc = "toggle file panel" } },
					{ "n", "gf", actions.goto_file_edit, { desc = "Open the file in the previous tabpage" } },
					{ "n", "co", actions.conflict_choose_all("ours"), { desc = "Choose conflict --ours" } },
					{ "n", "ct", actions.conflict_choose_all("theirs"), { desc = "Choose conflict --theirs" } },
					{ "n", "cb", actions.conflict_choose_all("base"), { desc = "Choose conflict --base" } },
					{ "n", "g?", actions.help("view"), { desc = "Open the help panel" } },
				},
				file_panel = {
					{ "n", "q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
					{ "n", "<Leader>e", actions.toggle_files, { desc = "toggle file panel" } },
					{ "n", "j", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
					{ "n", "<down>", actions.select_next_entry, { desc = "Select the next file entry" } },
					{ "n", "k", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
					{ "n", "<up>", actions.select_prev_entry, { desc = "Select the previous file entry" } },
					{ "n", "<cr>", actions.select_entry, { desc = "Open the diff for the selected entry" } },
					{ "n", "s", actions.toggle_stage_entry, { desc = "Stage/unstage the selected entry" } },
					{ "n", "S", actions.stage_all, { desc = "Stage all entries" } },
					{ "n", "U", actions.unstage_all, { desc = "Unstage all entries" } },
					{ "n", "[x", actions.prev_conflict, { desc = "Go to prev conflict" } },
					{ "n", "]x", actions.next_conflict, { desc = "Go to next conflict" } },
					{ "n", "gf", actions.goto_file_edit, { desc = "Open the file in the previous tabpage" } },
					{ "n", "co", actions.conflict_choose_all("ours"), { desc = "Choose conflict --ours" } },
					{ "n", "ct", actions.conflict_choose_all("theirs"), { desc = "Choose conflict --theirs" } },
					{ "n", "cb", actions.conflict_choose_all("base"), { desc = "Choose conflict --base" } },
					{ "n", "l", actions.open_fold, { desc = "Expand fold" } },
					{ "n", "h", actions.close_fold, { desc = "Collapse fold" } },
					{ "n", "t", actions.listing_style, { desc = "Toggle between 'list' and 'tree' views" } },
					{ "n", "L", actions.open_commit_log, { desc = "Open the commit log panel" } },
					{ "n", "g?", actions.help("file_panel"), { desc = "Open the help panel" } },
					{
						"n",
						"cc",
						function()
							vim.ui.input({ prompt = "Commit message: " }, function(msg)
								if not msg then
									return
								end
								local results = vim.system({ "git", "commit", "-m", msg }, { text = true }):wait()
								vim.notify(results.stdout, vim.log.levels.INFO, { title = "Commit", render = "simple" })
							end)
						end,
					},
					{
						"n",
						"cx",
						function()
							local results = vim.system({ "git", "commit", "--amend", "--no-edit" }, { text = true }):wait()
							vim.notify(results.stdout, vim.log.levels.INFO, { title = "Commit amend", render = "simple" })
						end,
					},
				},
				file_history_panel = {
					{ "n", "q", "<CMD>DiffviewClose<CR>", { desc = "Close DiffView" } },
					{ "n", "<Leader>e", actions.toggle_files, { desc = "toggle file panel" } },
					{ "n", "j", actions.next_entry, { desc = "Bring the cursor to the next log entry" } },
					{ "n", "<down>", actions.select_next_entry, { desc = "Select the next log entry" } },
					{ "n", "k", actions.prev_entry, { desc = "Bring the cursor to the previous log entry." } },
					{ "n", "<up>", actions.select_prev_entry, { desc = "Select the previous file entry." } },
					{ "n", "<cr>", actions.select_entry, { desc = "Open the diff for the selected entry." } },
					{ "n", "gd", actions.open_in_diffview, { desc = "Open the entry under the cursor in a diffview" } },
					{ "n", "y", actions.copy_hash, { desc = "Copy the commit hash of the entry under the cursor" } },
					{ "n", "L", actions.open_commit_log, { desc = "Show commit details" } },
					{ "n", "gf", actions.goto_file_edit, { desc = "Open the file in the previous tabpage" } },
					{ "n", "g?", actions.help("file_history_panel"), { desc = "Open the help panel" } },
				},
				help_panel = {
					{ "n", "q", actions.close, { desc = "Close help menu" } },
				},
			},
		})
	end,
}
