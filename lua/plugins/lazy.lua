local M = {}

function M.bootstrap()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		print("Installing lazy.nvim...")
		local clone_cmd = {
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			lazypath,
		}
		local ok, result = pcall(vim.fn.system, clone_cmd)
		if not ok then
			error("Failed to install lazy.nvim: " .. result)
		end
		print("Installation complete")
	end
	vim.opt.runtimepath:prepend(lazypath)
end

function M.setup()
	-- Initialize lazy.nvim with plugins
	require("lazy").setup({
		-- Your plugins table
		require("plugins"),
	}, {
		-- Lazy.nvim options
		git = {
			url_format = "https://github.com/%s.git",
			default_url_format = "https://github.com/%s.git",
		},
		performance = {
			rtp = {
				disabled_plugins = {
					"gzip",
					"netrwPlugin",
					"tarPlugin",
					"tohtml",
					"tutor",
					"zipPlugin",
				},
			},
		},
		change_detection = {
			notify = false,
		},
	})
end

return M
