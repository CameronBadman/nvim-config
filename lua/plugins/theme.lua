-- ~/.config/nvim/lua/plugins/theme.lua
local M = {}

function M.setup()
	-- Theme configuration
	require("cyberdream").setup({
		-- Add any custom theme options here
		transparent = false,
		italic_comments = true,
		hide_inactive_statusline = false,
		diagnostic_virtual_text = true,
		telescope = true,
		nvimtree = true,
	})

	-- Set colorscheme
	vim.cmd("colorscheme cyberdream")

	-- Additional highlight customizations if needed
	-- vim.cmd([[
	--     highlight Normal guibg=NONE ctermbg=NONE
	--     highlight SignColumn guibg=NONE ctermbg=NONE
	-- ]])
end

return M
