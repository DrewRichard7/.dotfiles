require("snacks").setup({
	gh = { enabled = true },
	lazygit = { enabled = true },
  explorer = { enabled = true },
	picker = {
		enabled = true,
		sources = {
			gh_issue = {},
			gh_pr = {},
      explorer = {
        hidden = true,
        ignored = true,
      },
		},
	},
})
