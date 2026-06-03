require("blink.cmp").setup({
	keymap = {
		preset = "default",
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = {
		implementation = "lua",
	},
})
