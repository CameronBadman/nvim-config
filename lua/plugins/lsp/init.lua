M = {}

local function on_attach(client, bufnr)
	local opts = { noremap = true, silent = true }
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

	-- Disable formatting for LSP clients since we're using null-ls
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
end

function M.setup()
	local mason = require("mason")
	mason.setup()
	local lspconfig = require("lspconfig")
	local mason_lspconfig = require("mason-lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	mason_lspconfig.setup({
		ensure_installed = {
			"pyright",
			"lua_ls",
			"dockerls",
			"gopls",
			"clangd",
			"yamlls",
		},
	})

	local servers = {
		ts_ls = {
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
					suggest = {
						completeFunctionCalls = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
					suggest = {
						completeFunctionCalls = true,
					},
				},
			},
		},
		pyright = {
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "workspace",
						useLibraryCodeForTypes = true,
						typeCheckingMode = "basic",
						inlayHints = {
							variableTypes = true,
							functionReturnTypes = true,
							parameterTypes = true,
						},
					},
				},
			},
		},
		dockerls = {
			settings = {
				docker = {
					languageserver = {
						diagnostics = {
							deprecatedMaintainer = true,
							directiveCasing = true,
							emptyContinuationLine = true,
							instructionCasing = true,
							instructionCmdMultiple = true,
							instructionEntrypointMultiple = true,
							instructionHealthcheckMultiple = true,
							instructionJSONInSingleQuotes = true,
						},
						formatter = {
							ignoreMultilineInstructions = false,
						},
					},
				},
			},
		},
		clangd = {
			settings = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					clangdFileStatus = true,
					usePlaceholders = true,
					completeUnimported = true,
					semanticHighlighting = true,
				},
			},
		},
		gopls = {
			settings = {
				gopls = {
					completeUnimported = true,
					usePlaceholders = true,
					experimentalPostfixCompletions = true,
					semanticTokens = true,
					staticcheck = true,
					gofumpt = true,
					codelenses = {
						gc_details = true,
						generate = true,
						regenerate_cgo = true,
						test = true,
						tidy = true,
						upgrade_dependency = true,
						vendor = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					diagnosticsDelay = "500ms",
					symbolMatcher = "fuzzy",
					symbolStyle = "dynamic",
					vulncheck = "Imports",
					directoryFilters = {
						"-node_modules",
						"-vendor",
					},
				},
			},
		},
	}

	for server, config in pairs(servers) do
		config.on_attach = on_attach
		config.capabilities = capabilities
		lspconfig[server].setup(config)
	end
end

return M
