
require('nvim-tree').setup({
  -- General settings
  auto_reload_on_write = true,    -- Automatically reload the tree when files are written
  update_cwd = true,              -- Update the current working directory when opening a directory

  -- View settings
  view = {
    width = 30,                   -- Set the width of the NvimTree window
    side = 'left',                 -- Position it on the left side of the editor
  },

  -- Filters to hide files or directories
  filters = {
    dotfiles = false,             -- Show dotfiles like .git
    custom = {},                  -- Additional custom filters (e.g., ignore specific files)
    exclude = {'.git', 'node_modules'} -- Exclude certain files or folders
  },

  -- Git integration settings
  git = {
    enable = true,                -- Enable Git status icons
    ignore = false,               -- Show Git-ignored files
  },

  -- Diagnostics settings
  diagnostics = {
    enable = false,               -- Disable diagnostics in NvimTree
  },

  -- Icons settings
  renderer = {
    icons = {
      webdev_colors = true,       -- Use webdev icons (for HTML, CSS, JS)
      show = {
        git = true,               -- Show Git status icons
        folder = true,            -- Show folder icons
        file = true               -- Show file icons
      },
    }
  }
})

require'nvim-web-devicons'.set_icon({
  default = { icon = "", color = "#ffffff", name = "Default" },   -- Default file icon
  symlink = { icon = "", color = "#A8A8A8", name = "Symlink" },   -- Icon for symlinks
  folder = {
      arrow_open = { icon = "", color = "#A8A8A8", name = "FolderOpen" },  -- Open folder icon
      arrow_closed = { icon = "", color = "#A8A8A8", name = "FolderClosed" }, -- Closed folder icon
      default = { icon = "", color = "#A8A8A8", name = "Folder" },     -- Default folder icon
      open = { icon = "", color = "#A8A8A8", name = "FolderOpen" },        -- Open folder icon
      empty = { icon = "", color = "#A8A8A8", name = "FolderEmpty" },       -- Empty folder icon
      empty_open = { icon = "", color = "#A8A8A8", name = "FolderEmptyOpen" },  -- Empty open folder icon
  },
  py = { icon = "", color = "#3572A5", name = "Python" },  -- Python file icon
  js = { icon = "", color = "#F7DF1E", name = "JavaScript" },  -- JavaScript file icon
  html = { icon = "", color = "#E34F26", name = "HTML" },  -- HTML file icon
  css = { icon = "", color = "#563D7C", name = "CSS" },  -- CSS file icon
  md = { icon = "", color = "#000000", name = "Markdown" },  -- Markdown file icon
})

-- Keybinding to toggle NvimTree
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

