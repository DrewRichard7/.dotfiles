-- lua/plugins/lsp.lua

local function get_python_path()
  local cwd = vim.fn.getcwd()

  local candidates = {
    cwd .. "/.venv/Scripts/python.exe",
    cwd .. "/.venv/Scripts/python",
    cwd .. "/.venv/bin/python",
  }

  for _, path in ipairs(candidates) do
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end

  if vim.fn.executable("python") == 1 then
    return "python"
  end

  if vim.fn.executable("python3") == 1 then
    return "python3"
  end

  return nil
end

vim.lsp.config("basedpyright", {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
  settings = {
    python = {
      pythonPath = get_python_path(),
    },
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "basic",
      },
    },
  },
})

vim.lsp.config("ruff", {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
})

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim",  },
      },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
})

vim.lsp.config("sqls", {
  cmd = { "sqls" },
  filetypes = { "sql" },
  root_markers = { ".git" },
})

-- Disable Ruff hover so basedpyright owns hover/K
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
})

vim.lsp.enable({
  "basedpyright",
  "ruff",
  "lua_ls",
  "rust_analyzer",
  "sqls",
})
