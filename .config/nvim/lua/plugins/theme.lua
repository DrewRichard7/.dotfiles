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
    enabled = false,
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
    lazy = false,
    priority = 1000,
    config = function()
      require("black-diamond.init").setup({
        transparent = true,
      })
      vim.cmd.colorscheme("black-diamond")
    end,
  },
}
