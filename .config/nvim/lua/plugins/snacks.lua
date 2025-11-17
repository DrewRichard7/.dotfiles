return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = false,
      },
      indent = {
        enabled = false,
      },
      input = {
        enabled = false,
      },
      picker = {
        -- global defaults for all pickers
        hidden = true, -- include dotfiles
        ignored = false, -- do NOT respect .gitignore / .ignore
        exclude = {}, -- no extra excludes
        sources = {
          -- this must be "files", not "file"
          files = {
            hidden = true,
            ignored = false,
            exclude = {},
          },
        },
      },
    },
  },
}
