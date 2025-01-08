-- Neo-tree configuration
_G.FocusNeoTree = function()
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

require("neo-tree").setup({
	close_if_last_window = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,

	filesystem = {
		-- More advanced file system configurations
		follow_current_file = {
			enabled = true,
			leave_dirs_open = true,
		},
		use_libuv_file_watcher = true,
		hijack_netrw = true,

		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_by_name = {
				".DS_Store",
				"thumbs.db",
				".git",
			},
			never_show = {
				".git",
				".cache",
			},
		},

		-- Window configuration for file system view
		window = {
			width = 35,
			position = "left",
			mappings = {
				["<space>"] = "toggle_node",
				["<2-LeftMouse>"] = "open",
				["<cr>"] = "open",
				["<esc>"] = "revert_preview",
				["P"] = { "toggle_preview", config = { use_float = true } },
				["l"] = "focus_preview",
				["S"] = "open_split",
				["s"] = "open_vsplit",
				["t"] = "open_tabnew",
				["w"] = "open_with_window_picker",
				["C"] = "close_node",
				["z"] = "close_all_nodes",
				["Z"] = "expand_all_nodes",
				["a"] = {
					"add",
					config = {
						show_path = "none", -- "none", "relative", "absolute"
					},
				},
				["A"] = "add_directory",
				["d"] = "delete",
				["r"] = "rename",
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
				["c"] = "copy",
			},
		},
	},

	default_component_configs = {
		icon = {
			folder_empty = "󰗿",
			default = "📄",
		},
		name = {
			trailing_slash = true,
			use_git_status_colors = true,
		},
		git_status = {
			symbols = {
				added = "✚",
				modified = "✎",
				deleted = "✖",
				renamed = "➜",
				untracked = "★",
				ignored = "◌",
				unstaged = "✗",
				staged = "✓",
				conflict = "",
			},
		},
		diagnostics = {
			symbols = {
				hint = "💡",
				info = "ℹ️",
				warn = "⚠️",
				error = "❌",
			},
			highlights = {
				hint = "DiagnosticSignHint",
				info = "DiagnosticSignInfo",
				warn = "DiagnosticSignWarn",
				error = "DiagnosticSignError",
			},
		},
	},

	-- Open Neo-tree automatically on startup if no files were specified
	open_on_startup = function()
		-- Only open if no files were specified when launching Neovim
		return vim.fn.argc() == 0
	end,

	-- Additional window configurations
	window = {
		position = "left",
		width = 35,
		mapping_options = {
			noremap = true,
			nowait = true,
		},
		mappings = {
			["<space>"] = {
				"toggle_node",
				nowait = false,
			},
			["<2-LeftMouse>"] = "open",
			["<cr>"] = "open",
			["<esc>"] = "revert_preview",
			["P"] = { "toggle_preview", config = { use_float = true } },
			["l"] = "focus_preview",
		},
	},
})

-- Keybindings
vim.api.nvim_set_keymap(
	"n",
	"<leader>e",
	":lua FocusNeoTree()<CR>",
	{ noremap = true, silent = true, desc = "Focus Neo-tree" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>E",
	":Neotree toggle<CR>",
	{ noremap = true, silent = true, desc = "Toggle Neo-tree" }
)

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

return {} -- Make it a proper module
