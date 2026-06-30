local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Enable semantic tokens
capabilities.textDocument = capabilities.textDocument or {}
capabilities.textDocument.semanticTokens = {
	dynamicRegistration = false,
	requests = {
		range = false,
		full = true,
	},
	tokenTypes = {
		"namespace",
		"class",
		"enum",
		"interface",
		"struct",
		"typeParameter",
		"type",
		"parameter",
		"variable",
		"property",
		"enumMember",
		"decorator",
		"event",
		"function",
		"method",
		"macro",
		"label",
		"comment",
		"string",
		"keyword",
		"number",
		"regexp",
		"operator",
	},
	tokenModifiers = {
		"declaration",
		"definition",
		"readonly",
		"static",
		"deprecated",
		"abstract",
		"async",
		"modification",
		"documentation",
		"defaultLibrary",
	},
	formats = { "relative" },
}

-- Enable formatting
capabilities.textDocument.formatting = {
	dynamicRegistration = false,
}

-- Enable folding range support
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

---@type vim.lsp.Config
local config = {
	cmd = { "devicetree-language-server", "--stdio" },
	filetypes = { "dts", "dtsi" },
	root_markers = { "zephyr", ".git" },
	settings = {
		devicetree = {
			defaultIncludePaths = {
				"./zephyr/dts",
				"./zephyr/dts/arm",
				"./zephyr/dts/arm64/",
				"./zephyr/dts/riscv",
				"./zephyr/dts/common",
				"./zephyr/dts/vendor",
				"./zephyr/include",
				"./zmk/app/dts",
				"./zmk/app/include",
				"./zmk-behavior-runtime-sensor-rotate/src",
			},
			cwd = "${workspaceFolder}",
			defaultBindingType = "Zephyr",
			defaultZephyrBindings = {
				"./zephyr/dts/bindings",
				"./zmk/app/dts/bindings",
			},
			autoChangeContext = true,
			allowAdhocContexts = true,
			contexts = {},
		},
	},
	capabilities = capabilities,
}

return config
