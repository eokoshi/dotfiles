-- if having annoying clipboard behavior, it might be this plugin
return {
	"aserowy/tmux.nvim",
	event = "VeryLazy",
	opts = {
		copy_sync = {
			sync_registers_keymap_reg = false,
		},
	},
}
