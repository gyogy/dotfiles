require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "lua", "javascript" },  -- Specify your preferred languages

  -- Enable highlighting
  highlight = {
    enable = true,  -- Enable Treesitter-based highlighting
    additional_vim_regex_highlighting = false,  -- Disable Vim's default highlighting
  },

  -- Enable indenting based on Treesitter
  indent = {
    enable = true,  -- Enable Treesitter-based indentation
  },
}
