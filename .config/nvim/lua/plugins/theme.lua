local local_theme_file = vim.fn.stdpath("config") .. "/lua/config/local_theme.lua"

if vim.fn.filereadable(local_theme_file) == 1 then
	dofile(local_theme_file)
	return
end

require("tokyonight").setup({})
vim.cmd.colorscheme("tokyonight")
