-- Bootstrap lazy.nvim
require("plugins.lazy").bootstrap()

-- Load core configurations
require("config").setup()

-- Initialize plugins
require("plugins.lazy").setup()
