-- Customize Treesitter

---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"lua",
			"vim",
			"python",
			"bash",
			"markdown",
			"markdown_inline",
			"json",
			"jsonc",
			"ssh_config",
			"sql",
			"toml",
			"r",
			"git_config",
			"dockerfile",
			-- add more arguments for adding more treesitter parsers
		},
		highlight = {
			disable = {
				"csv",
				"tsv",
				"csv_semicolon",
				"csv_whitespace",
				"csv_pipe",
				"rfc_csv",
				"rfc_semicolon",
			},
		},
	},
}
