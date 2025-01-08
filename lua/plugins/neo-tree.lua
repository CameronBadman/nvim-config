local M = {}

local function focus_neo_tree()
	local neo_tree_wins = vim.tbl_filter(function(win)
		local buf = vim.api.nvim_win_get_buf(win)
		return vim.bo[buf].filetype == "neo-tree"
	end, vim.api.nvim_list_wins())

	if #neo_tree_wins > 0 then
		vim.api.nvim_set_current_win(neo_tree_wins[1])
	else
		vim.cmd("Neotree show")
	end
end

function M.setup()
	-- Make FocusNeoTree available globally
	_G.FocusNeoTree = focus_neo_tree

	require("neo-tree").setup({
		close_if_last_window = true,
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,

		filesystem = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = true,
			},
			use_libuv_file_watcher = true,
			hijack_netrw_behavior = "open_default",
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
		},

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
						show_path = "none",
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
	})

	-- Set up autocommand for startup behavior
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			if vim.fn.argc() == 0 then
				vim.defer_fn(function()
					vim.cmd("Neotree show")
				end, 10)
			end
		end,
	})
end

return M
