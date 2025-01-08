local M = {}

function M.setup()
	-- Configure vsnip
	vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
	local friendly_snippets_path = vim.fn.stdpath("data") .. "/lazy/friendly-snippets/snippets"
	vim.g.vsnip_snippet_dirs = { friendly_snippets_path }

	-- Configure LuaSnip
	require("luasnip").setup({
		history = true,
		delete_check_events = "TextChanged",
	})

	-- Load VSCode-style snippets
	require("luasnip.loaders.from_vscode").lazy_load()

	-- Add command to open snippet list
	vim.api.nvim_create_user_command("SnipList", function()
		vim.cmd("VsnipOpen")
	end, {})

	-- Optional: Add keymaps for snippet navigation
	local opts = { noremap = true, silent = true }
	vim.keymap.set({ "i", "s" }, "<C-j>", function()
		if require("luasnip").jumpable(1) then
			require("luasnip").jump(1)
		end
	end, opts)

	vim.keymap.set({ "i", "s" }, "<C-k>", function()
		if require("luasnip").jumpable(-1) then
			require("luasnip").jump(-1)
		end
	end, opts)
end

return M
