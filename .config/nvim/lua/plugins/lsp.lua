return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts.servers = opts.servers or {}

      -- Lua
      opts.servers.lua_ls = opts.servers.lua_ls or {}

      -- BasedPyright for type checking
      opts.servers.basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
              -- Ruff will do unused checks; silence these in BasedPyright
              reportUnusedImport = "none",
              reportUnusedVariable = "none",
            },
          },
        },
      }

      -- Ruff LSP for linting diagnostics
      opts.servers.ruff = {
        init_options = {
          settings = {
            args = {
              "--line-length=88",
              "--select=E,F,I,B,UP,SIM,ARG",
            },
          },
        },
      }

      opts.servers.jsonls = opts.servers.jsonls or {}
      opts.servers.yamlls = opts.servers.yamlls or {}
      opts.servers.rust_analyzer = opts.servers.rust_analyzer or {}

      -- keep your “remove gr keymap” logic if you still want it:
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
        "stylua",
        "ruff",
        "basedpyright",
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
