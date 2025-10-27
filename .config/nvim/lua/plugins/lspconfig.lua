return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        vim.lsp.config.pyright = {
            cmd = { "pyright-langserver", "--stdio" },
            filetypes = { "python" },
            root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
        }
        vim.lsp.start(vim.lsp.config.pyright)
    end,
}
