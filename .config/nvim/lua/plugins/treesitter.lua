return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup {
            ensure_installed = { "bash", "html", "javascript", "json", "lua", "python" },
            indent = { enable = true },
            highlight = {
                enable = true,  -- <- fix this key!
                additional_vim_regex_highlighting = false,
            },
        }
    end
}
