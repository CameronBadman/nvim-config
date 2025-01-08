local M = {}

function M.setup()
	local opt = vim.opt

	-- Basic settings
	opt.encoding = "utf-8"
	opt.fileencoding = "utf-8"
	opt.backup = false
	opt.swapfile = false
	opt.undofile = true
	opt.clipboard = "unnamedplus"

	-- UI settings
	opt.number = true
	opt.relativenumber = true
	opt.showmode = false
	opt.signcolumn = "yes"
	opt.cursorline = true
	opt.termguicolors = true
	opt.splitbelow = true
	opt.splitright = true

	-- Indentation
	opt.expandtab = true
	opt.shiftwidth = 4
	opt.tabstop = 4
	opt.smartindent = true
	opt.autoindent = true

	-- Search
	opt.ignorecase = true
	opt.smartcase = true
	opt.hlsearch = true
	opt.incsearch = true

	-- Performance
	opt.hidden = true
	opt.updatetime = 300
	opt.timeoutlen = 500

	-- Window
	opt.scrolloff = 8
	opt.sidescrolloff = 8
	opt.wrap = false

	-- Completion
	opt.completeopt = "menu,menuone,noselect"
end

return M
