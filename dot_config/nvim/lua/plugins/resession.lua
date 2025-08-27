-- if true then return {} end

return {
	{
		"stevearc/resession.nvim",
		opts = {
			autosave = {
				enabled = true,
				interval = 60,
				notify = false,
			},
		},
		init = function()
			local resession = require("resession")
			local function get_session_name()
				local name = vim.fn.getcwd()
				local branch = vim.trim(vim.fn.system("git branch --show-current"))
				if vim.v.shell_error == 0 then
					return name .. branch
				else
					return name
				end
			end
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					resession.save(get_session_name(), { dir = "dirsession", notify = false })
				end,
			})
		end,
	},
}
