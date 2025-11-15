return {
  {
    "bjarneo/ash.nvim",
    enabled = true,
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
}
