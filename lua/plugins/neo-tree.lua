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
	},
	window = {
		width = 30, -- Width of the file explorer window
		position = "left", -- Position of the file explorer (left or right)
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
