local M = {}

function M.setup()
	-- Theme configuration
	require("cyberdream").setup({
		transparent = true,
		italic_comments = true,
		hide_inactive_statusline = false,
		diagnostic_virtual_text = true,
		telescope = true,
		nvimtree = true,
	})

	-- Set up base colors to match Alacritty
	local colors = {
		bg = "#1d1f21",
		fg = "#c5c8c6",
		black = "#1d1f21",
		bright_black = "#666666",
		red = "#cc6666",
		bright_red = "#d54e53",
		green = "#b5bd68",
		bright_green = "#b9ca4a",
		yellow = "#f0c674",
		bright_yellow = "#e7c547",
		blue = "#81a2be",
		bright_blue = "#7aa6da",
		magenta = "#b294bb",
		bright_magenta = "#c397d8",
		cyan = "#8abeb7",
		bright_cyan = "#70c0b1",
		white = "#c5c8c6",
		bright_white = "#eaeaea",
		selection_bg = "#3e4451",
	}

	-- Set colorscheme
	vim.cmd("colorscheme cyberdream")

	-- Set transparency and color overrides
	local hi = vim.api.nvim_set_hl
	hi(0, "Normal", { fg = colors.fg, bg = "NONE" })
	hi(0, "NormalFloat", { fg = colors.fg, bg = "NONE" })
	hi(0, "SignColumn", { bg = "NONE" })
	hi(0, "NeoTreeNormal", { bg = "NONE" })
	hi(0, "NeoTreeNormalNC", { bg = "NONE" })
	hi(0, "LineNr", { fg = colors.bright_black, bg = "NONE" })
	hi(0, "CursorLine", { bg = colors.selection_bg })
	hi(0, "CursorLineNr", { fg = colors.bright_white, bg = "NONE", bold = true })
	hi(0, "Visual", { bg = colors.selection_bg })

	-- Set terminal colors
	vim.g.terminal_color_0 = colors.black
	vim.g.terminal_color_1 = colors.red
	vim.g.terminal_color_2 = colors.green
	vim.g.terminal_color_3 = colors.yellow
	vim.g.terminal_color_4 = colors.blue
	vim.g.terminal_color_5 = colors.magenta
	vim.g.terminal_color_6 = colors.cyan
	vim.g.terminal_color_7 = colors.white
	vim.g.terminal_color_8 = colors.bright_black
	vim.g.terminal_color_9 = colors.bright_red
	vim.g.terminal_color_10 = colors.bright_green
	vim.g.terminal_color_11 = colors.bright_yellow
	vim.g.terminal_color_12 = colors.bright_blue
	vim.g.terminal_color_13 = colors.bright_magenta
	vim.g.terminal_color_14 = colors.bright_cyan
	vim.g.terminal_color_15 = colors.bright_white

	-- Set window transparency level to match Alacritty (0.85)
	vim.g.neovim_transparency = 85
end

return M
