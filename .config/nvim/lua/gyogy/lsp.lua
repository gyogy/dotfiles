local lspconfig = require('lspconfig')

-- LSP setup for Python (Pyright)
lspconfig.pyright.setup{
  -- Explicitly define the command to run pyright-langserver with the --stdio flag
  cmd = { "/usr/bin/node", "/usr/local/bin/pyright-langserver", "--stdio" },

  -- Define the root directory, use the current working directory (can be adjusted as needed)
  root_dir = function(fname)
    return vim.loop.cwd()  -- You can customize this to use a specific folder or project structure
  end,

  -- Define actions when the language server attaches
  on_attach = function(client, bufnr)
    -- Add any actions for on_attach, e.g., setting keymaps, configuring diagnostics, etc.
  end,

  -- Configure Pyright settings (e.g., Python analysis settings)
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
  },
}

-- Add additional LSP configurations for other languages (if necessary)
-- lspconfig.tsserver.setup{}
-- lspconfig.sumneko_lua.setup{}
-- More language servers can be added here

