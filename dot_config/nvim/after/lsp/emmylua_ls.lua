return {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path .. "/.emmyrc.json") or vim.uv.fs_stat(path .. "/.luarc.json")) then
				client.config.settings = {}
			end
		end
	end,
	settings = {
		emmylua = {
			runtime = {
				version = "LuaJIT",
				requirePattern = {
					"?.lua",
					"?/init.lua",
				},
			},
			diagnostics = { globals = { "vim" }, disable = { "preferred-local-alias", "unnecessary-if" } },
			workspace = {
				library = {
					vim.fn.stdpath("config"),
					vim.fn.stdpath("data") .. "/site/pack/core/opt",
					vim.fn.expand("$VIMRUNTIME/lua"),
					vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
				},
			},
		},
	},
}
