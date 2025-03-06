require('gyogy.plugins')
require('gyogy.lsp')
require('gyogy.cmp')
require('gyogy.keymaps')
require('gyogy.colorscheme')
require('gyogy.treesitter')
require('gyogy.nvim-tree')

-- Stop pretending you're vi
vim.opt.compatible = false

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

-- REMAPS
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('v', 'kj', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('c', 'kj', '<C-C>', { noremap = true })

-- Quicker split movement
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true })

-- Set timeout in insert mode
vim.opt.timeoutlen = 500

-- Finding Files
vim.opt.path:append("**")
vim.opt.wildmenu = true

-- Cursor Style (Insert Mode: Line, Normal Mode: Block)
vim.opt.guicursor = "n-v-c:block,i-ci:ver25"
