-- Auto-install packer if missing
local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.cmd([[packadd packer.nvim]])
end

-- Reload Neovim when saving this file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Plugin list
return require("packer").startup(function(use)
    use "wbthomason/packer.nvim" -- the packet manager
    use {
        "tiagovla/tokyodark.nvim",
        config = function()
            require("tokyodark").setup({
                transparent_background = false,
                gamma = 1.0,
            })
            vim.cmd.colorscheme("tokyodark")
        end
    }
    use {
        "nvim-tree/nvim-tree.lua",
        requires = {
            "nvim-tree/nvim-web-devicons", -- optional, for file icons
        },
        config = function()
            require("nvim-tree").setup({})
        end
    }
end)

