-- if true then return {} end

return {
	"stevearc/resession.nvim",
	opts = {
		autosave = {
			enabled = true,
			interval = 60,
			notify = false,
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function()
				-- Always save a special session named "last"
				require("resession").save("last")
			end,
			desc = "Save session on exit",
		})
	end,
}
