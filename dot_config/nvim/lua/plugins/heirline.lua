return {
	"rebelot/heirline.nvim",
	opts = function(_, opts)
		local status = require("astroui.status")
		opts.statusline = {
			hl = { fg = "fg", bg = "bg" },
			status.component.mode({
				mode_text = { padding = { left = 1, right = 1 } },
			}), -- add the mode text
			status.component.git_branch(),
			status.component.file_info({
				filename = {
					fallback = "",
					modify = ":p:~:.",
				},
				filetype = false,
				paddings = { right = 1 },
				file_read_only = false,
			}),
			status.component.git_diff(),
			status.component.diagnostics(),
			status.component.fill(),
			status.component.cmd_info(),
			status.component.fill(),
			status.component.lsp(),
			status.component.virtual_env(),
			status.component.treesitter(),
			status.component.nav(),
		}
	end,
}
