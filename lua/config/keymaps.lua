local M = {}

local function smart_quit()
	local bufnr = vim.api.nvim_get_current_buf()
	local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
	local buf_type = vim.api.nvim_buf_get_option(bufnr, "buftype")

	-- Don't save changes for special buffers
	if buf_type == "nofile" or buf_type == "prompt" or buf_type == "help" then
		vim.cmd("q!")
		return
	end

	-- If buffer is modified, prompt to save changes
	if modified then
		local choice = vim.fn.confirm("Save changes before quitting?", "&Yes\n&No\n&Cancel", 1)
		if choice == 1 then -- Yes
			vim.cmd("write")
			vim.cmd("q")
		elseif choice == 2 then -- No
			vim.cmd("q!")
		end
		-- Choice 3 (Cancel) does nothing
	else
		-- If it's the last buffer, quit Neovim
		if #vim.fn.getbufinfo({ buflisted = 1 }) == 1 then
			vim.cmd("q")
		else
			-- If there are more buffers, just close this one
			vim.cmd("bd")
		end
	end
end

function M.setup()
	-- Set leader key
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- Better window navigation
	vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate left window" })
	vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate down window" })
	vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate up window" })
	vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate right window" })

	-- Resize with arrows
	vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window up" })
	vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize window down" })
	vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
	vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })

	-- Navigate buffers
	vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
	vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

	-- Stay in indent mode
	vim.keymap.set("v", "<", "<gv", { desc = "Indent left and stay in visual mode" })
	vim.keymap.set("v", ">", ">gv", { desc = "Indent right and stay in visual mode" })

	-- Move text up and down
	vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
	vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

	-- Better paste
	vim.keymap.set("v", "p", '"_dP', { desc = "Better paste" })

	-- Clear highlights
	vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

	-- Close buffers
	vim.keymap.set("n", "<leader>q", smart_quit, { desc = "Smart quit" })
	vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all" })

	-- Better save
	vim.keymap.set("n", "<leader>w", "<cmd>w!<CR>", { desc = "Save" })
	vim.keymap.set("n", "<leader>W", "<cmd>wa!<CR>", { desc = "Save all" })

	-- Split windows
	vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
	vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
	vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
	vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

	-- Tabs
	vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
	vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
	vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Next tab" })
	vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Previous tab" })

	-- Diagnostics
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
	vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })

	-- Terminal
	vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Terminal navigate left" })
	vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Terminal navigate down" })
	vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Terminal navigate up" })
	vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Terminal navigate right" })

	-- Quick escape from insert mode
	vim.keymap.set("i", "jk", "<ESC>", { desc = "Quick escape" })
	vim.keymap.set("i", "kj", "<ESC>", { desc = "Quick escape" })
end

return M
