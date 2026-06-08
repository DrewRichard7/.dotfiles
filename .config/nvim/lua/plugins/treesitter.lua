local ts = require("nvim-treesitter")

ts.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

local parsers = {
	"python",
	"lua",
	"rust",
	"sql",
	"bash",
	"markdown",
	"markdown_inline",
	"html",
	"latex",
	"yaml",
}

ts.install(parsers)

vim.api.nvim_create_autocmd("FileType", {
	pattern = parsers,
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})
