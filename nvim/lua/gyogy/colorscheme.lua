-- Define your default configuration
local default_config = {
    transparent_background = false,
    gamma = 1.00,
    styles = {
        comments = { italic = false },
        keywords = { italic = false },
        identifiers = { italic = true },
        functions = {},
        variables = {},
    },
    custom_highlights = {} or function(highlights, palette) return {} end,
    custom_palette = {} or function(palette) return {} end,
    terminal_colors = true,
}

-- Set the configuration before loading the colorscheme
require('tokyodark').setup(default_config)

-- Apply the colorscheme
vim.cmd('colorscheme tokyodark')
