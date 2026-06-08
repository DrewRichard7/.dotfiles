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

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"rust_analyzer",
		"gopls",
		"vtsls",
		"tailwindcss",
		"basedpyright",
		"ruff",
	},
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({
				capabilities = capabilities,
			})
		end,

		zls = function()
			local lspconfig = require("lspconfig")
			lspconfig.zls.setup({
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
				settings = {
					zls = {
						enable_inlay_hints = true,
						enable_snippets = true,
						warn_style = true,
					},
				},
			})
			vim.g.zig_fmt_parse_errors = 0
			vim.g.zig_fmt_autosave = 0
		end,

		lua_ls = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						format = {
							enable = true,
							defaultConfig = {
								indent_style = "space",
								indent_size = "2",
							},
						},
					},
				},
			})
		end,

		tailwindcss = function()
			local lspconfig = require("lspconfig")
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
					"svelte",
					"heex",
				},
			})
		end,

		basedpyright = function()
			local lspconfig = require("lspconfig")
			lspconfig.basedpyright.setup({
				capabilities = capabilities,
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
		end,

		ruff = function()
			local lspconfig = require("lspconfig")
			lspconfig.ruff.setup({
				capabilities = capabilities,
				init_options = {
					settings = {
						organizeImports = true,
					},
				},
			})
		end,
	},
})

-- Disable Ruff hover so basedpyright owns hover
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end
	end,
})
