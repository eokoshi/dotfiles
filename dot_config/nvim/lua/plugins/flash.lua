-- if true then return {} end

return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		modes = {
			char = {
				autohide = true,
			},
			search = {
				-- enabled = true,
			},
		},
		label = {
			rainbow = {
				enabled = true,
				shade = 6,
			},
		},
		prompt = {
			enabled = false,
		},
	},
	-- stylua: ignore 
	keys = {
		{ "+",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
		{ "H",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
		{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
	},
}
