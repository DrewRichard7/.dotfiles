return {
  {
    "bjarneo/ash.nvim",
    enabled = false,
    priority = 1000,
    config = function()
      require("ash").setup({
        disable = {
          background = true,
        },
      })
      vim.cmd("colorscheme ash")
    end,
  },
  -- lua/plugins/rose-pine.lua
  {
    "rose-pine/neovim",
    enabled = true,
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        styles = {
          transparency = true,
        },
      })
      vim.cmd("colorscheme rose-pine")
    end,
  },
  {
    name = "black-diamond",
    dir = "/Users/andrew/dev/nvim-plugins/black-diamond.nvim/",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("black-diamond.init").setup({
        transparent = true,
      })
      vim.cmd.colorscheme("black-diamond")
    end,
  },
  {
    "ribru17/bamboo.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("bamboo").setup({
        style = "multiplex",
        lualine = {
          transparent = true,
        },
      })
      require("bamboo").load()
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    enabled = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        transparent = true,
        dimInactive = false,
        terminalColors = true,
        theme = "wave",
        background = { dark = "wave", light = "lotus" },
        colors = {
          -- palette = {},
          theme = { all = { ui = { bg_gutter = "none" } } },
        },
        overrides = function(colors)
          return { Visual = { bg = "#87ceeb" } }
        end,
      })
      vim.cmd.colorscheme("kanagawa")
      vim.api.nvim_set_hl(0, "TermCursor", { fg = "#A6E3A1", bg = "#A6E3A1" })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    enabled = false,
    config = function()
      vim.cmd.colorscheme("kanagawa")
      vim.cmd([[
  highlight! link SignColumn Normal
  highlight! link LineNr     Normal
  highlight! link FoldColumn Normal
]])
    end,
  },
  {
    "neanias/everforest-nvim",
    enabled = false,
    priority = 1000,
    config = function()
      require("everforest").setup({
        background = "hard",
        transparent_background_level = 0,
        ui_contrast = "high",

        -- Force palette background to match Ghostty Everforest Dark Hard
        colours_override = function(palette)
          -- main editor background
          -- palette.bg0 = "#1e2326"
          palette.bg0 = "#1E2326"
          -- you can also tweak nearby shades if you want tighter matching:
          -- palette.bg1 = "#272e33"
          -- palette.bg2 = "#2e383c"
        end,
      })

      vim.o.background = "dark"

      -- load after setup so overrides take effect
      vim.cmd.colorscheme("everforest")

      -- (Optional) Make sure Normal uses that bg explicitly
      -- in case you want to be extra strict:
      -- vim.api.nvim_set_hl(0, "Normal", { bg = "#1e2326" })
      -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1e2326" })
    end,
  },
  {
    "tiagovla/tokyodark.nvim",
    enabled = false,
    priority = 1000,
    opts = {
      -- custom options here
    },
    config = function(_, opts)
      require("tokyodark").setup(opts) -- calling setup is optional
      vim.cmd([[colorscheme tokyodark]])
    end,
  },
  {
    "thesimonho/kanagawa-paper.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme("kanagawa-paper-ink")
      -- vim.cmd.colorscheme("kanagawa-paper")
    end,
  },
  {
    "adibhanna/yukinord.nvim",
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme yukinord")

      -- Option 1: keep Yukinord's foregrounds, just remove bg
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "NONE" })

      -- If you want them all to be "ghosty" like comments instead, use this
      -- (uncomment if you prefer this behavior):
      -- local comment = vim.api.nvim_get_hl(0, { name = "Comment" }).fg
      -- for _, group in ipairs({
      --   "DiagnosticVirtualTextError",
      --   "DiagnosticVirtualTextWarn",
      --   "DiagnosticVirtualTextInfo",
      --   "DiagnosticVirtualTextHint",
      -- }) do
      --   vim.api.nvim_set_hl(0, group, { fg = comment, bg = "NONE" })
      -- end
    end,
  },
}
