-- if true then return {} end

return {
	"brenoprata10/nvim-highlight-colors",
	event = "VeryLazy",
	opts = {
		render = "virtual",
		virtual_symbol = "[]",
		virtual_symbol_position = "eow",
		virtual_symbol_prefix = " ",
		virtual_symbol_suffix = "",
	},
}
