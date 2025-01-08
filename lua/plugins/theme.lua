local M = {}

function M.setup()
	-- Theme configuration
	require("cyberdream").setup({
		transparent = true,
		italic_comments = true,
		hide_inactive_statusline = false,
		diagnostic_virtual_text = true,
		telescope = true,
		nvimtree = true,
	})

	-- Set colorscheme
	vim.cmd("colorscheme cyberdream")

	-- Additional transparency tweaks
	vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE" })
end

return M
