local M = {}
M.setup = function()
  require("cyberdream").setup({
    -- Enable transparent background
    transparent = true,
    -- Enable italics comments
    italic_comments = true,
    -- Replace all fillchars with ' ' for the ultimate clean look
    hide_fillchars = false,
    -- Modern borderless telescope theme
    borderless_telescope = true,
    -- Set terminal colors
    terminal_colors = true,
    -- Cache highlights for better performance
    cache = true,
    theme = {
      variant = "default",
      saturation = 1,
      highlights = {
        -- UI element highlights
        Normal = { bg = "NONE", ctermbg = "NONE" },
        NormalNC = { bg = "NONE", ctermbg = "NONE" },
        SignColumn = { bg = "NONE", ctermbg = "NONE" },
        MsgArea = { bg = "NONE", ctermbg = "NONE" },
        TelescopeBorder = { bg = "NONE", ctermbg = "NONE" },
        NvimTreeNormal = { bg = "NONE", ctermbg = "NONE" },
        LineNr = { bg = "NONE", ctermbg = "NONE" },
        CursorLineNr = { bg = "NONE", ctermbg = "NONE" },
        EndOfBuffer = { bg = "NONE", ctermbg = "NONE" },
        VertSplit = { bg = "NONE", ctermbg = "NONE" },
        StatusLine = { bg = "NONE", ctermbg = "NONE" },
      },
      colors = {
        -- Customize your colors
        bg = "#000000",
        green = "#00ff00",
        cyan = "#00ffff",
        magenta = "#ff00ff",
        blue = "#00b3ff",
        red = "#ff0055",
        orange = "#ff9500"
      },
    },
    extensions = {
      telescope = true,
      notify = true,
      mini = true,
    },
  })
end

return M
