-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
	"AstroNvim/astrocommunity",
	-- { import = "astrocommunity.pack.lua" },
	-- { import = "astrocommunity.pack.python" },
	{ import = "astrocommunity.motion.nvim-surround" },
	{ import = "astrocommunity.git.gitgraph-nvim" },
	{ import = "astrocommunity.colorscheme.catppuccin" },
	{ import = "astrocommunity.colorscheme.bluloco-nvim" },
	{ import = "astrocommunity.colorscheme.onedarkpro-nvim" },
	{ import = "astrocommunity.colorscheme.gruvbox-nvim" },
	-- { import = "astrocommunity.utility.hover-nvim" },
	-- import/override with your plugins folder
}
