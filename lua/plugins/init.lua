-- Initialize lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
print("Lazy path: " .. lazypath)

if not vim.loop.fs_stat(lazypath) then
	print("Installing lazy.nvim...")
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"git@github.com:folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	}
	local result = vim.fn.system(clone_cmd)
	print("Installation result: " .. vim.inspect(result))
end

-- Verify the directory exists
local stat = vim.loop.fs_stat(lazypath)
print("Directory exists after install: " .. tostring(stat ~= nil))

vim.opt.runtimepath:prepend(lazypath)
vim.g.mapleader = " "

-- Add a small delay to ensure everything is loaded
vim.defer_fn(function()
	require("lazy").setup({
		-- Your existing plugin config...
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
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- We'll create this file next if you need LSP configuration
			require("plugins.lsp")
		end,
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
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = {
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				},
				experimental = {
					ghost_text = true,
				},
			})
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
			-- We'll create this file next if you need Telescope configuration
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
			-- This loads your custom theme configuration from themes/cyberdream.lua
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
			-- We'll create this file next if you need Neo-tree configuration
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
})
