-- ~/.config/nvim/lua/plugins/lsp/sonarlint.lua

local M = {}

function M.setup(opts)
	local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")

	local config = vim.tbl_deep_extend("force", {
		server = {
			cmd = {
				"/usr/lib/jvm/java-23-openjdk/bin/java",
				"-jar",
				mason_path .. "packages/sonarlint-language-server/extension/server/sonarlint-ls.jar",
				"-stdio",
				"-analyzers",
				mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonarjs.jar",
				mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonarpython.jar",
				mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonarcfamily.jar",
				mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonarjava.jar",
				mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonargo.jar",
				mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonarhtml.jar",
			},
		},
		filetypes = {
			"javascript",
			"typescript",
			"python",
			"java",
			"cpp",
			"c",
			"go",
		},
		settings = {
			sonarlint = {
				-- Comprehensive rule configuration for security and code quality
				enabled = true,
				rules = {
					-- Global security and secret detection rules
					javascript = {
						-- Secret and credential detection
						["javascript:S2068"] = "on", -- Hardcoded credentials
						["javascript:S1943"] = "on", -- Credentials should not be hardcoded

						-- Security vulnerabilities
						["javascript:S5689"] = "on", -- Using eval is security-sensitive
						["javascript:S2076"] = "on", -- Executing shell commands is security-sensitive
						["javascript:S2732"] = "on", -- Using command injection is security-sensitive

						-- Code quality and potential bugs
						["javascript:S1848"] = "on", -- Function call with side effects
						["javascript:S1125"] = "on", -- Unnecessary boolean literals
						["javascript:S3923"] = "on", -- Branches with same implementation
						["javascript:S1172"] = "on", -- Unused function parameters
						["javascript:S1186"] = "on", -- Empty function
						["javascript:S3403"] = "on", -- Redundant boolean comparison
					},

					typescript = {
						-- Similar rules for TypeScript
						["typescript:S2068"] = "on", -- Hardcoded credentials
						["typescript:S1943"] = "on", -- Credentials should not be hardcoded
						["typescript:S5689"] = "on", -- Using eval is security-sensitive
						["typescript:S2076"] = "on", -- Executing shell commands is security-sensitive
						["typescript:S2732"] = "on", -- Using command injection is security-sensitive
						["typescript:S1848"] = "on",
						["typescript:S1125"] = "on",
						["typescript:S3923"] = "on",
						["typescript:S1172"] = "on",
						["typescript:S1186"] = "on",
						["typescript:S3403"] = "on",
					},

					python = {
						-- Python-specific security and secret rules
						["python:S2068"] = "on", -- Hardcoded credentials
						["python:S1943"] = "on", -- Credentials should not be hardcoded
						["python:S5689"] = "on", -- Eval is security-sensitive
						["python:S2076"] = "on", -- Executing shell commands is security-sensitive
						["python:S2732"] = "on", -- Command injection is security-sensitive
						["python:S1481"] = "on", -- Unused local variables
						["python:S1186"] = "on", -- Empty function
						["python:S3403"] = "on", -- Redundant boolean comparison
					},

					java = {
						-- Java security and secret detection
						["java:S2068"] = "on", -- Hardcoded credentials
						["java:S1943"] = "on", -- Credentials should not be hardcoded
						["java:S5689"] = "on", -- Eval-like methods are security-sensitive
						["java:S2076"] = "on", -- Executing commands is security-sensitive
						["java:S2732"] = "on", -- Command injection is security-sensitive
						["java:S1481"] = "on", -- Unused local variables
						["java:S1186"] = "on", -- Empty method
						["java:S3403"] = "on", -- Redundant boolean comparison
					},

					cpp = {
						-- C++ security rules
						["cpp:S2068"] = "on", -- Hardcoded credentials
						["cpp:S1943"] = "on", -- Credentials should not be hardcoded
						["cpp:S5689"] = "on", -- Eval-like functions are security-sensitive
						["cpp:S2076"] = "on", -- Executing commands is security-sensitive
						["cpp:S2732"] = "on", -- Command injection is security-sensitive
					},

					c = {
						-- C security rules
						["c:S2068"] = "on", -- Hardcoded credentials
						["c:S1943"] = "on", -- Credentials should not be hardcoded
						["c:S5689"] = "on", -- Eval-like functions are security-sensitive
						["c:S2076"] = "on", -- Executing commands is security-sensitive
						["c:S2732"] = "on", -- Command injection is security-sensitive
					},

					go = {
						-- Go security and best practice rules
						["go:S2068"] = "on", -- Hardcoded credentials
						["go:S1943"] = "on", -- Credentials should not be hardcoded
						["go:S5689"] = "on", -- Eval-like functions are security-sensitive
						["go:S2076"] = "on", -- Executing commands is security-sensitive
						["go:S2732"] = "on", -- Command injection is security-sensitive
						["go:S1481"] = "on", -- Unused variables
						["go:S1186"] = "on", -- Empty function
						["go:S3403"] = "on", -- Redundant boolean comparison
						["go:S4663"] = "on", -- Cognitive complexity of functions
						["go:S1313"] = "on", -- Hard-coded IP addresses
						["go:S2004"] = "on", -- Slow cryptographic algorithms
					},

					rust = {
						-- Rust security and best practice rules
						["rust:S2068"] = "on", -- Hardcoded credentials
						["rust:S1943"] = "on", -- Credentials should not be hardcoded
						["rust:S5689"] = "on", -- Eval-like functions are security-sensitive
						["rust:S2076"] = "on", -- Executing commands is security-sensitive
						["rust:S2732"] = "on", -- Command injection is security-sensitive
						["rust:S1481"] = "on", -- Unused variables
						["rust:S1186"] = "on", -- Empty function
						["rust:S3403"] = "on", -- Redundant boolean comparison
						["rust:S4663"] = "on", -- Cognitive complexity of functions
						["rust:S1313"] = "on", -- Hard-coded IP addresses
						["rust:S2004"] = "on", -- Weak cryptographic algorithms
						["rust:S4790"] = "on", -- Sensitive information exposure
						["rust:S5728"] = "on", -- Weak SSL/TLS configurations
					},
				},
			},
		},
	}, opts or {})

	require("sonarlint").setup(config)

	-- Force LSP to attach
	vim.api.nvim_create_autocmd("FileType", {
		pattern = config.filetypes,
		callback = function()
			vim.cmd("LspStart sonarlint")
		end,
	})
end

return M
