local M = {}

function M.setup()
	-- Load all configuration modules
	require("config.options").setup()
	require("config.keymaps").setup()
	require("config.diagnostics").setup()
end

return M
