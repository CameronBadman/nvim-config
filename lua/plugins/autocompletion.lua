local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			-- Use a snippet engine like vsnip or luasnip
			vim.fn["vsnip#anonymous"](args.body) -- assuming you use vsnip for snippets
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(), -- Previous completion item
		["<C-n>"] = cmp.mapping.select_next_item(), -- Next completion item
		["<C-d>"] = cmp.mapping.scroll_docs(-4), -- Scroll documentation up
		["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll documentation down
		["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion
		["<C-e>"] = cmp.mapping.close(), -- Close completion
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selected completion item
	},
	sources = {
		{ name = "nvim_lsp" }, -- LSP source for autocompletion
		{ name = "buffer" }, -- Buffer source for text already in the current buffer
		{ name = "path" }, -- Path source for file path completion
	},
	experimental = {
		native_menu = false, -- Disable the native menu for completions
		ghost_text = true, -- Show ghost text for suggestions
	},
})
