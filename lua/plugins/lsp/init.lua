local M = {}

-- Enhanced on_attach function with formatting capabilities
local function on_attach(client, bufnr)
	local opts = { noremap = true, silent = true }
	-- Core LSP mappings
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

	-- LSP diagnostics mappings
	vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

	-- Format on save
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end
end

function M.setup()
	local mason_lspconfig = require("mason-lspconfig")
	local lspconfig = require("lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	-- Mason LSP setup
	mason_lspconfig.setup({
		ensure_installed = {
			"pyright",
			"typescript-language-server",
			"lua_ls",
			"dockerls",
			"gopls",
			"clangd",
			"yamlls",
		},
		automatic_installation = true,
	})

	-- Setup handlers for all servers
	mason_lspconfig.setup_handlers({
		function(server_name)
			local opts = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- Server-specific settings
			if server_name == "lua_ls" then
				opts.settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				}
			elseif server_name == "yamlls" then
				opts.settings = {
					yaml = {
						schemas = {
							kubernetes = "/*.k8s.yaml",
							["docker-compose"] = "/*docker-compose.yml",
						},
					},
				}
			end

			lspconfig[server_name].setup(opts)
		end,
	})
end

return M
