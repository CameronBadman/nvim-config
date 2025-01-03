-- plugins/linting.lua

-- Import the null-ls plugin
local null_ls = require("null-ls")

-- Define the sources we want to use
local sources = {
	-- We'll start with just a few essential linters and add more as needed

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

-- Configure null-ls with our sources
null_ls.setup({
	-- Register the sources we defined above
	sources = sources,

	-- Configure how diagnostics appear
	diagnostics_format = "[#{c}] #{m} (#{s})",

	-- Set up automatic formatting on save
	on_attach = function(client, bufnr)
		-- Only attach to clients that support formatting
		if client.supports_method("textDocument/formatting") then
			-- Create an autocommand group for this buffer
			local augroup = vim.api.nvim_create_augroup("LspFormatting_" .. bufnr, { clear = true })

			-- Add the autocommand to format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- Format the buffer
					vim.lsp.buf.format({
						bufnr = bufnr,
						-- Only use null-ls for formatting
						filter = function(client)
							return client.name == "null-ls"
						end,
						timeout_ms = 2000, -- Timeout after 2 seconds
					})
				end,
			})
		end
	end,
})

-- Add helpful key mappings for formatting
vim.keymap.set("n", "<leader>lf", function()
	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
	})
end, { noremap = true, desc = "Format current buffer" })
