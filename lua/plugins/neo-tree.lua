-- Neo-tree configuration
require("neo-tree").setup({
	close_if_last_window = true, -- Close the file explorer if it's the last window
	filesystem = {
		follow_current_file = true, -- Follow the current file in the explorer
		use_libuv_file_watcher = true, -- Use libuv file watcher for faster updates
		hijack_netrw = true, -- Hijack netrw to prevent the default file explorer
		filtered_items = {
			visible = true, -- Show hidden files by default
			hide_dotfiles = false, -- Don't hide dotfiles
		},
		-- Automatically open Neo-tree on startup if no files were specified
		window = {
			-- Preserve existing window configuration
			width = 30,
			position = "left",
		},
	},
	default_component_configs = {
		icon = {
			folder_empty = "󰗿", -- Custom folder icon for empty folders
		},
		name = {
			trailing_slash = true, -- Show trailing slash for directories
		},
		git_status = {
			symbols = {
				added = "✚",
				modified = "✎",
				deleted = "✖",
			},
		},
	},
	-- Open Neo-tree automatically on startup if no files were specified
	open_on_startup = function()
		-- Only open if no files were specified when launching Neovim
		if vim.fn.argc() == 0 then
			return true
		end
		return false
	end,
})

-- Function to focus Neo-tree without closing it
function FocusNeoTree()
	-- Check if Neo-tree is already open
	local is_open = vim.fn.win_findbuf(vim.fn.bufnr("neo-tree")) ~= nil
	if is_open then
		-- If it's open, just focus on it
		vim.cmd("Neotree focus")
	else
		-- If not open, open it
		vim.cmd("Neotree toggle")
	end
end

-- Keybindings:
-- <leader>e will focus the Neo-tree window, but will not close it if it's already focused.
vim.api.nvim_set_keymap("n", "<leader>e", ":lua FocusNeoTree()<CR>", { noremap = true, silent = true })
-- <leader>E will toggle the Neo-tree (open if closed, close if open)
vim.api.nvim_set_keymap("n", "<leader>E", ":Neotree toggle<CR>", { noremap = true, silent = true })

-- Additional fallback to ensure Neo-tree opens if the startup option doesn't work
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			vim.defer_fn(function()
				vim.cmd("Neotree")
			end, 10)
		end
	end,
})
