-- lua/plugins/lualine.lua

local M = {}

M.setup = function()
	-- Color table for highlights
	local colors = {
		bg = "#202328",
		fg = "#bbc2cf",
		yellow = "#ECBE7B",
		cyan = "#008080",
		darkblue = "#081633",
		green = "#98be65",
		orange = "#FF8800",
		violet = "#a9a1e1",
		magenta = "#c678dd",
		blue = "#51afef",
		red = "#ec5f67",
	}

	local conditions = {
		buffer_not_empty = function()
			return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
		end,
		hide_in_width = function()
			return vim.fn.winwidth(0) > 80
		end,
		check_git_workspace = function()
			local filepath = vim.fn.expand("%:p:h")
			local gitdir = vim.fn.finddir(".git", filepath .. ";")
			return gitdir and #gitdir > 0 and #gitdir < #filepath
		end,
	}

	local config = {
		options = {
			component_separators = "",
			section_separators = "",
			theme = {
				normal = { c = { fg = colors.fg, bg = colors.bg } },
				inactive = { c = { fg = colors.fg, bg = colors.bg } },
			},
		},
		sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_y = {},
			lualine_z = {},
			lualine_c = {},
			lualine_x = {},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_y = {},
			lualine_z = {},
			lualine_c = {},
			lualine_x = {},
		},
	}

	-- Function to insert components into left or right sections
	local function ins_left(component)
		table.insert(config.sections.lualine_c, component)
	end
	local function ins_right(component)
		table.insert(config.sections.lualine_x, component)
	end

	-- Adding left section components
	ins_left({
		function()
			return "▊"
		end,
		color = { fg = colors.blue },
		padding = { left = 0, right = 1 },
	})

	ins_left({
		-- Mode component
		function()
			return ""
		end,
		color = function()
			local mode_color = {
				n = colors.red,
				i = colors.green,
				v = colors.blue,
				["␖"] = colors.blue,
				V = colors.blue,
				c = colors.magenta,
				no = colors.red,
				s = colors.orange,
				S = colors.orange,
				["␓"] = colors.orange,
				ic = colors.yellow,
				R = colors.violet,
				Rv = colors.violet,
				cv = colors.red,
				ce = colors.red,
				r = colors.cyan,
				rm = colors.cyan,
				["r?"] = colors.cyan,
				["!"] = colors.red,
				t = colors.red,
			}
			return { fg = mode_color[vim.fn.mode()] }
		end,
		padding = { right = 1 },
	})

	ins_left({
		-- Filesize component
		"filesize",
		cond = conditions.buffer_not_empty,
	})

	ins_left({
		"filename",
		cond = conditions.buffer_not_empty,
		color = { fg = colors.magenta, gui = "bold" },
	})

	-- Show the current directory or file path
	ins_left({
		function()
			return vim.fn.fnamemodify(vim.fn.getcwd(), ":t") -- Show the current directory name
		end,
		color = { fg = colors.cyan },
		padding = { left = 1, right = 1 },
	})

	-- Add technology-related icons based on filetype (defaults included)
	ins_left({
		function()
			local filetype = vim.bo.filetype
			local symbol, color

			-- Define the symbol and color for the specific filetypes
			if filetype == "go" then
				symbol, color = "🐹", colors.green
			elseif filetype == "rust" then
				symbol, color = "🦀", colors.orange
			elseif filetype == "python" then
				symbol, color = "🐍", colors.blue
			elseif filetype == "javascript" or filetype == "javascriptreact" then
				symbol, color = "📜", colors.yellow
			elseif filetype == "yaml" and vim.fn.expand("%:t") == "kubernetes.yaml" then
				symbol, color = "☸️", colors.cyan
			elseif filetype == "yaml" and vim.fn.expand("%:t") == "docker-compose.yaml" then
				symbol, color = "🐳", colors.red
			elseif filetype == "terraform" then
				symbol, color = "🌍", colors.green
			elseif filetype == "cs" then
				symbol, color = "⚙️", colors.magenta
			elseif filetype == "lua" then
				symbol, color = "", colors.green
			else
				return ""
			end

			return symbol .. " | " .. vim.fn.expand("%:t") -- Display symbol and filename
		end,
		color = function()
			local filetype = vim.bo.filetype
			-- Provide color based on filetype
			if filetype == "go" then
				return { fg = colors.green }
			elseif filetype == "rust" then
				return { fg = colors.orange }
			elseif filetype == "python" then
				return { fg = colors.blue }
			elseif filetype == "javascript" or filetype == "javascriptreact" then
				return { fg = colors.yellow }
			elseif filetype == "yaml" then
				return { fg = colors.cyan }
			elseif filetype == "terraform" then
				return { fg = colors.green }
			elseif filetype == "cs" then
				return { fg = colors.magenta }
			elseif filetype == "lua" then
				return { fg = colors.green }
			end
			return { fg = colors.fg }
		end,
	})

	-- Mid section to add separator
	ins_left({
		function()
			return "%="
		end,
	})

	-- LSP status component
	ins_left({
		function()
			local msg = "No Active LSP"
			local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
			local clients = vim.lsp.get_clients()
			if next(clients) == nil then
				return msg
			end
			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
					return client.name
				end
			end
			return msg
		end,
		icon = " LSP:",
		color = { fg = "#ffffff", gui = "bold" },
	})

	-- Right section components
	ins_right({
		"o:encoding",
		fmt = string.upper,
		cond = conditions.hide_in_width,
		color = { fg = colors.green, gui = "bold" },
	})

	ins_right({
		"fileformat",
		fmt = string.upper,
		icons_enabled = false,
		color = { fg = colors.green, gui = "bold" },
	})

	-- Git branch component
	ins_right({
		"branch",
		icon = "",
		color = { fg = colors.violet, gui = "bold" },
	})

	ins_right({
		"diff",
		symbols = { added = " ", modified = "󰝤 ", removed = " " },
		diff_color = {
			added = { fg = colors.green },
			modified = { fg = colors.orange },
			removed = { fg = colors.red },
		},
		cond = conditions.hide_in_width,
	})

	ins_right({
		function()
			return "▊"
		end,
		color = { fg = colors.blue },
		padding = { left = 1 },
	})

	-- Initialize lualine
	require("lualine").setup(config)
end

return M
