local M = {}

function M.setup()
    -- General keymaps
    vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
    vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
    vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })
    
    -- Window navigation
    vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
    vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
    vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
    vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
    
    -- Buffer navigation
    vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
    vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
    
    -- Better indenting
    vim.keymap.set("v", "<", "<gv")
    vim.keymap.set("v", ">", ">gv")
    
    -- Move lines
    vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
    vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
end

return M, { noremap = true, silent = true })
