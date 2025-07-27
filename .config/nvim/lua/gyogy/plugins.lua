local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            "git",
            "clone",
            "--depth", "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path
        })
        vim.cmd("packadd packer.nvim")
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
    use "wbthomason/packer.nvim"
    use "neovim/nvim-lspconfig"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp"
    use "saadparwaiz1/cmp_luasnip"
    use "tpope/vim-fugitive"
    use "kyazdani42/nvim-tree.lua"
    use "nvim-tree/nvim-web-devicons"
    use "tiagovla/tokyodark.nvim"
    use "navarasu/onedark.nvim"
    use "nvim-treesitter/nvim-treesitter"
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "nvim-tree/nvim-web-devicons" }
    }

    if packer_bootstrap then
        print("[packer] Bootstrapping... restart Neovim when done.")
        require("packer").sync()
    end
end)

-- Delay loading plugin configs if packer is bootstrapping
if not packer_bootstrap then
    vim.schedule(function()
        require("gyogy.lsp")
        require("gyogy.cmp")
        require("gyogy.keymaps")
        require("gyogy.colorscheme")
        require("gyogy.treesitter")
        require("gyogy.nvim-tree")
        require("gyogy.lualine")
    end)
end
