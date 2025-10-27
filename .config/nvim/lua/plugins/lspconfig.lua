return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        -- new API
        vim.lsp.config["pyright"].setup({})
    end,
}

