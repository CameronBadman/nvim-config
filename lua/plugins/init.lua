local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	print("Installing lazy.nvim...")
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", -- Changed from SSH to HTTPS
		"--branch=stable",
		lazypath,
	}
	local result = vim.fn.system(clone_cmd)
	print("Installation result: " .. vim.inspect(result))
end

vim.opt.runtimepath:prepend(lazypath)
vim.g.mapleader = " "

-- Add a small delay to ensure everything is loaded
vim.defer_fn(function()
	require("lazy").setup({
		git = {
			url_format = "https://github.com/%s.git", -- Added this
			default_url_format = "https://github.com/%s.git", -- Added this
		},
	})
end, 100)

-- We'll store all our plugin configurations here
return require("lazy").setup({
	-- Core functionality plugins
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "python", "typescript", "javascript" },
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	"nvim-lua/plenary.nvim", -- Required by several plugins

	-- Git integration with fugitive
	{
		"tpope/vim-fugitive",
		config = function()
			-- Add some helpful keymaps for common git operations
			vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
			vim.keymap.set("n", "<leader>gd", ":Gdiff<CR>", { desc = "Git diff" })
			vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
			vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "Git log" })
		end,
	},

	-- LSP stack with Mason for management
	{
		"williamboman/mason.nvim",
		priority = 100, -- Load early
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason").setup()
			require("plugins.lsp").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("plugins.lsp").setup()
		end,
		event = { "BufReadPre", "BufNewFile" },
	},
	-- Autocompletion with nvim-cmp
	{
		"hrsh7th/nvim-cmp",
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

	-- File navigation with Telescope
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("plugins.telescope")
		end,
	},

	-- Status line with Lualine
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "cyberdream", -- Match your theme
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

	-- Theme configuration
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false, -- Load immediately
		priority = 1000, -- Ensure it loads before other plugins
		config = function()
			require("themes.cyberdream").setup()
			vim.cmd("colorscheme cyberdream")
		end,
	},

	-- File explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("plugins.neo-tree")
		end,
	},

	-- Kubernetes integration
	{
		"ramilito/kubectl.nvim",
		config = function()
			require("kubectl").setup()
			require("plugins.kubectl")
		end,
	},

	-- Documentation generation
	{
		"danymat/neogen",
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
			-- Map to Alt+Shift+D like IntelliJ
			vim.keymap.set(
				"n",
				"<M-S-d>",
				":lua require('neogen').generate()<CR>",
				{ noremap = true, silent = true, desc = "Generate documentation" }
			)
		end,
	},

	-- Linting and formatting support
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("plugins.linting")
		end,
	},

	-- Snippet support
	{
		"hrsh7th/vim-vsnip",
		dependencies = {
			{ "rafamadriz/friendly-snippets" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
		config = function()
			vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"

			-- Debug: Print the snippets directories
			print("Snippet dirs:", vim.inspect(vim.g.vsnip_snippet_dirs))

			-- Ensure the friendly-snippets path is correct
			local friendly_snippets_path = vim.fn.stdpath("data") .. "/lazy/friendly-snippets/snippets"
			vim.g.vsnip_snippet_dirs = { friendly_snippets_path }

			-- Load LuaSnip snippets
			require("luasnip").setup({})
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Add a debug command to check available snippets
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
			local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
			require("sonarlint").setup({
				server = {
					cmd = {
						"sonarlint-language-server",
						"-stdio",
						"-analyzers",
						-- The analyzers are actually located in the sonarlint-language-server package
						mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonarjs.jar",
						mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonarts.jar",
						mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonarjava.jar",
						mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonarpy.jar",
						mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonargo.jar",
						mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonarcfamily.jar",
						mason_path .. "packages/sonarlint-language-server/extension/analyzers/sonarhtml.jar",
					},
				},
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"python",
					"java",
					"go",
					"cpp",
					"c",
					"html",
				},
			})
		end,
	},
})
