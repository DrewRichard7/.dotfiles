return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Start with lazyvim defaults
      opts = opts or {}
      opts.servers = opts.servers or {}

      --2 merge custom server config on top
      opts.servers.lua_ls = opts.servers.lua_ls or {}
      opts.servers.pyright = opts.servers.pyright or {}
      opts.servers.ruff = opts.servers.ruff or {}
      opts.servers.jsonls = opts.servers.jsonls or {}
      opts.servers.yamlls = opts.servers.yamlls or {}
      opts.servers.rust_analyzer = opts.servers.rust_analyzer or {}

      -- remove lazyvim's 'gr' lsp keymap which interferes with neovim's defautl globals
      opts.servers["*"] = opts.servers["*"] or {}
      local keys = opts.servers["*"].keys or {}

      local filtered = {}
      for _, key in ipairs(keys) do
        if key[1] ~= "gr" then
          table.insert(filtered, key)
        end
      end

      opts.servers["*"].keys = filtered

      return opts
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua", -- formatter only
        -- other tools that aren't LSP servers
      },
    },
  },
}

-- below is a working lsp; above is trying to restore neovim's default global lsp keymaps
-- return {
--   {
--     "neovim/nvim-lspconfig",
--     opts = {
--       servers = {
--         lua_ls = {},
--         -- basedpyright = {
--         --   settings = {
--         --     basedpyright = {
--         --       analysis = {
--         --         typeCheckingMode = "standard",
--         --       },
--         --     },
--         --   },
--         -- },
--         pyright = {},
--         ruff = {},
--         jsonls = {},
--         yamlls = {},
--         rust_analyzer = {},
--       },
--     },
--     -- capabilities = {},
--   },
--   {
--     "mason-org/mason.nvim",
--     opts = {
--       ensure_installed = {
--         "stylua", -- formatter only
--         -- other tools that aren't LSP servers
--       },
--     },
--   },
-- }
