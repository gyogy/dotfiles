require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'tpope/vim-fugitive'
    use 'kyazdani42/nvim-tree.lua'
    use 'tiagovla/tokyodark.nvim'
    use 'nvim-treesitter/nvim-treesitter'  -- This line should be present
end)
