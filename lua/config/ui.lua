-- Basic UI settings
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false -- We'll show mode in lualine instead
vim.opt.laststatus = 3 -- Global statusline

-- Transparency settings
vim.opt.pumblend = 15 -- Makes popup menu transparent
vim.opt.winblend = 15 -- Makes floating windows transparent
