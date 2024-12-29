


-- lsp/init.lua
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

-- Function to ensure the language server setup
local function on_attach(client, bufnr)
  -- Key mappings for LSP actions (e.g., go to definition, show hover info, etc.)
  local opts = { noremap = true, silent = true }

  -- Example key mappings for LSP
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  
  -- LSP diagnostics key mappings
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>d', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

-- Mason LSP configuration
mason_lspconfig.setup({
  ensure_installed = { "pyright", "ts_ls", "lua_ls" },  -- List of LSPs to install
  automatic_installation = true,  -- Automatically install missing LSPs
})

-- Setup each LSP
lspconfig.pyright.setup({
  on_attach = on_attach,  -- Attach the LSP configurations
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",  -- Adjust Python type checking
      },
    },
  },
})


lspconfig.ts_ls.setup({
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    typescript = {
      format = { enable = true },  -- Enable formatting for TypeScript
    },
  },
})

lspconfig.lua_ls.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },  -- Enable vim global for Lua LSP
      },
    },
  },
})

-- You can add additional language server setups here as needed
-- Example:
-- lspconfig.rust_analyzer.setup({ on_attach = on_attach })

