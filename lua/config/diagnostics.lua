local M = {}

function M.setup()
	vim.diagnostic.config({
		virtual_text = {
			source = true,
			severity = {
				min = vim.diagnostic.severity.HINT,
			},
		},
		float = {
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})

	-- Diagnostic signs
	local signs = {
		{ name = "DiagnosticSignError", text = "✘" },
		{ name = "DiagnosticSignWarn", text = "▲" },
		{ name = "DiagnosticSignHint", text = "⚑" },
		{ name = "DiagnosticSignInfo", text = "»" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end
end

return M
