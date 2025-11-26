require("blink-cmp").setup({
	keymap = {
		preset = "default",
		["<CR>"] = { "fallback" },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = {
			ignore_version_mismatch = true,
		},
	},
	completion = {
		documentation = { auto_show = false },
	},
})
