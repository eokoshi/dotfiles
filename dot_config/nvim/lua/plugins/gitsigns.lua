return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	opts = {
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local map = require("stuff.functions").map

			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					require("gitsigns").nav_hunk({ "next" })
				end
			end, { desc = "Next hunk", buffer = bufnr })
			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					require("gitsigns").nav_hunk({ "prev" })
				end
			end, { desc = "Prev hunk", buffer = bufnr })

			-- Actions
			map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk", buffer = bufnr })
			map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk", buffer = bufnr })
			map("v", "<leader>gs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Stage hunk", buffer = bufnr })
			map("v", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Stage hunk", buffer = bufnr })
			map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer", buffer = bufnr })
			map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer", buffer = bufnr })
			map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk", buffer = bufnr })
			map("n", "<leader>gP", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline", buffer = bufnr })
			map("n", "<leader>gx", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "Blame line", buffer = bufnr })
			map("n", "<leader>gX", gitsigns.blame, { desc = "Blame", buffer = bufnr })
			map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff", buffer = bufnr })
			map("n", "<leader>gq", gitsigns.setqflist, { desc = "Quickfix file changes", buffer = bufnr })
			map("n", "<leader>gQ", function()
				gitsigns.setqflist("all")
			end, { desc = "Quickfix all changes", buffer = bufnr })

			-- Toggles
			map("n", "<leader>gc", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame virt text", buffer = bufnr })
			map("n", "<leader>gw", gitsigns.toggle_word_diff, { desc = "Toggle word diff", buffer = bufnr })

			-- Text object
			map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "inside hunk", buffer = bufnr })
			map({ "o", "x" }, "ah", gitsigns.select_hunk, { desc = "around hunk", buffer = bufnr })
		end,
	},
}
