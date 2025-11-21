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
      require("everforest").setup({})
      vim.cmd.colorscheme("everforest")
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
}
