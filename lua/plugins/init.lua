-- ~/.config/nvim/lua/plugins/init.lua

-- Bootstrap lazy.nvim
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

-- Set leader key
vim.g.mapleader = " "

-- Configure diagnostics globally
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

-- Return the plugin configuration
return require("lazy").setup({
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		version = "*",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"python",
					"typescript",
					"javascript",
					"go",
					"rust",
					"c",
					"cpp",
					"java",
					"json",
					"yaml",
					"toml",
					"html",
					"css",
					"markdown",
					"markdown_inline",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<CR>",
						node_decremental = "<BS>",
						scope_incremental = "<TAB>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]C"] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[C"] = "@class.outer",
						},
					},
				},
			})
		end,
	},

	{ "nvim-lua/plenary.nvim", lazy = false }, -- Required by several plugins

	-- Git integration
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
			vim.keymap.set("n", "<leader>gd", ":Gdiff<CR>", { desc = "Git diff" })
			vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
			vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "Git log" })
		end,
	},

	-- LSP stack
	{
		"williamboman/mason.nvim",
		priority = 100,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("plugins.lsp").setup()
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
		},
		config = function()
			require("plugins.autocompletion")
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("plugins.telescope")
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "cyberdream",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- Theme
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("themes.cyberdream").setup()
			vim.cmd("colorscheme cyberdream")
		end,
	},

	-- File explorer (Neo-tree)
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		cmd = "Neotree",
		keys = {
			{ "<leader>e", "<cmd>lua FocusNeoTree()<CR>", desc = "Focus Neo-tree" },
			{ "<leader>E", "<cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			-- Function to focus Neo-tree without closing it
			_G.FocusNeoTree = function()
				local is_open = vim.fn.win_findbuf(vim.fn.bufnr("neo-tree")) ~= nil
				if is_open then
					vim.cmd("Neotree focus")
				else
					vim.cmd("Neotree toggle")
				end
			end

			require("neo-tree").setup({
				close_if_last_window = true,
				filesystem = {
					follow_current_file = true,
					use_libuv_file_watcher = true,
					hijack_netrw = true,
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
					},
				},
				window = {
					width = 30,
					position = "left",
				},
				default_component_configs = {
					icon = {
						folder_empty = "󰗿",
					},
					name = {
						trailing_slash = true,
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
		end,
	},

	-- Kubernetes integration
	{
		"ramilito/kubectl.nvim",
		cmd = "Kubectl",
		config = function()
			require("kubectl").setup()
			require("plugins.kubectl")
		end,
	},

	-- Documentation generation
	{
		"danymat/neogen",
		cmd = "Neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("neogen").setup({
				enabled = true,
				languages = {
					python = {
						template = {
							annotation_convention = "google_docstrings",
						},
					},
					javascript = {
						template = {
							annotation_convention = "jsdoc",
						},
					},
					typescript = {
						template = {
							annotation_convention = "tsdoc",
						},
					},
				},
			})
			vim.keymap.set(
				"n",
				"<M-S-d>",
				":lua require('neogen').generate()<CR>",
				{ noremap = true, silent = true, desc = "Generate documentation" }
			)
		end,
	},

	-- Linting and formatting
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("plugins.linting")
		end,
	},

	-- Snippets
	{
		"hrsh7th/vim-vsnip",
		event = "InsertEnter",
		dependencies = {
			{ "rafamadriz/friendly-snippets" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
		config = function()
			vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
			local friendly_snippets_path = vim.fn.stdpath("data") .. "/lazy/friendly-snippets/snippets"
			vim.g.vsnip_snippet_dirs = { friendly_snippets_path }

			require("luasnip").setup({})
			require("luasnip.loaders.from_vscode").lazy_load()

			vim.api.nvim_create_user_command("SnipList", function()
				vim.cmd("VsnipOpen")
			end, {})
		end,
	},

	-- SonarLint integration
	{
		"https://gitlab.com/schrieveslaach/sonarlint.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		config = function()
			require("plugins.lsp.sonarlint").setup()
		end,
	},
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
