

-- plugins/telescope.lua
local telescope = require("telescope")
local actions = require("telescope.actions")

-- Setup Telescope with default settings
telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,  -- Close telescope on ESC
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",  -- Visual tweaks for better UX
      hidden = true,  -- Show hidden files
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,  -- Enable fuzzy matching
      override_generic_sorter = true,  -- Override default sorter with fzf
      override_file_sorter = true,  -- Override file sorter with fzf
    },
  },
})

-- Load the fzf extension if installed
telescope.load_extension("fzf")

-- Keymaps for Telescope
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { noremap = true, silent = true })

