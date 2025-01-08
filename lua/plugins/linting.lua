local M = {}

local function setup_format_on_save(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		local augroup = vim.api.nvim_create_augroup("LspFormatting_" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({
					bufnr = bufnr,
					filter = function(client)
						return client.name == "null-ls"
					end,
					timeout_ms = 2000,
				})
			end,
		})
	end
end

function M.setup()
	local null_ls = require("null-ls")

	-- Define the sources we want to use
	local sources = {
		-- Python formatting and linting
		null_ls.builtins.formatting.black.with({
			condition = function()
				return vim.fn.executable("black") == 1
			end,
		}),

		-- Lua formatting
		null_ls.builtins.formatting.stylua.with({
			condition = function()
				return vim.fn.executable("stylua") == 1
			end,
		}),

		-- General purpose formatter
		null_ls.builtins.formatting.prettier.with({
			condition = function()
				return vim.fn.executable("prettier") == 1
			end,
		}),

		-- Basic spell checking
		null_ls.builtins.diagnostics.codespell.with({
			condition = function()
				return vim.fn.executable("codespell") == 1
			end,
		}),
	}

	-- Configure null-ls
	null_ls.setup({
		sources = sources,
		diagnostics_format = "[#{c}] #{m} (#{s})",
		on_attach = setup_format_on_save,
	})

	-- Add helpful key mappings for formatting
	vim.keymap.set("n", "<leader>lf", function()
		vim.lsp.buf.format({
			filter = function(client)
				return client.name == "null-ls"
			end,
		})
	end, { noremap = true, desc = "Format current buffer" })
end

return M
