return {
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
			require("plugins.treesitter").setup()
		end,
	},

	{ "nvim-lua/plenary.nvim", lazy = false },

	-- Git integration
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		config = function()
			require("plugins.git").setup()
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
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("plugins.autocompletion").setup()
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			require("plugins.telescope").setup()
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("plugins.statusline").setup()
		end,
	},

	-- Theme
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("plugins.theme").setup()
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
			require("plugins.neo-tree").setup()
		end,
	},

	-- Kubernetes integration
	{
		"ramilito/kubectl.nvim",
		cmd = "Kubectl",
		config = function()
			require("plugins.kubectl").setup()
		end,
	},

	-- Documentation generation
	{
		"danymat/neogen",
		cmd = "Neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("plugins.documentation").setup()
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
			require("plugins.linting").setup()
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
			require("plugins.snippets").setup()
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
}
