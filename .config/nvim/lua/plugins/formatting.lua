require("conform").setup({
  format_on_save = {
    timeout_ms = 5000,
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = {"stylua"},
    python = {"ruff"},
    rust = {"rust_analyzer"}
  }
})

require("nvim-autopairs").setup()
