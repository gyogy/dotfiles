-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- disable netrw for nvim-tree's sake
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Keybindings for common actions
vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>o', ':lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>t', ':10 split | term<CR>', { noremap = true, silent = true })

-- KJ for Esc
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('v', 'kj', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('c', 'kj', '<C-C>', { noremap = true })

-- Quicker split movement
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true })

-- Stop pretending you're vi
vim.opt.compatible = false

-- Keep vim motions when inserting/ searching Bulgariain
vim.opt.keymap = "bulgarian-phonetic"
vim.opt.iminsert = 0
vim.opt.imsearch = 0

-- SYNTAX
vim.cmd("syntax enable")
vim.cmd("filetype plugin on")

-- LINE NUMBERS
vim.opt.number = true
vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd({"BufEnter", "FocusGained", "InsertLeave", "WinEnter"}, {
  group = "numbertoggle",
  pattern = "*",
  command = "if &nu && mode() != 'i' | set rnu | endif"
})
vim.api.nvim_create_autocmd({"BufLeave", "FocusLost", "InsertEnter", "WinLeave"}, {
  group = "numbertoggle",
  pattern = "*",
  command = "if &nu | set nornu | endif"
})

-- TAB SETTINGS
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Misc Settings
vim.opt.swapfile = false
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.wrap = false
vim.opt.textwidth = 79
vim.opt.colorcolumn = "80"
vim.opt.termguicolors = true

-- TITLE BAR
vim.opt.title = true
vim.opt.titlestring = "%f"

-- STATUS BAR
vim.opt.laststatus = 2
vim.opt.statusline = "%!getcwd()"

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Set timeout in insert mode
vim.opt.timeoutlen = 500

-- Finding Files
vim.opt.path:append("**")
vim.opt.wildmenu = true

-- Cursor Style (Insert Mode: Line, Normal Mode: Block)
vim.opt.guicursor = "n-v-c:block,i-ci:ver25"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
  -- disable luarocks
  rocks = { enabled = false }
})

-- Auto-update
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyCheck",
    callback = function()
        require("lazy").update({ show = false })
    end,
})

