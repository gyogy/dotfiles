return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                python = { "isort", "black" },
                json = { "jq" },
                text = { "softwrap_plain_text" },
                [""] = { "softwrap_plain_text" },
                ["*"] = { "trim_whitespace" },
            },

        format_on_save = function(bufnr)
            local ft = vim.bo[bufnr].filetype
            if ft == "text" or ft == "" then
                return false -- skip for plain text
            end
            return { timeout_ms = 2000, lsp_format = "fallback" }
        end,


        -- Softwrap lines longer than textwidth in plain text
        formatters = {
            softwrap_plain_text = {
                format = function(_, ctx)
                    vim.api.nvim_buf_call(ctx.bufnr or 0, function()
                        vim.cmd("silent keepjumps keeppatterns %normal! gw$")
                    end)
                    return { text = nil }
                end,
            },
        },
    })


        -- <leader>f: format buffer / visual range; exit visual mode after formatting
        vim.keymap.set("", "<leader>f", function()
            require("conform").format({ async = true, lsp_format = "fallback" }, function(err)
                if not err then
                    local mode = vim.api.nvim_get_mode().mode
                    if vim.startswith(string.lower(mode), "v") then
                        vim.api.nvim_feedkeys(
                            vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                            "n",
                            true
                        )
                    end
                end
            end)
        end, { desc = "Format code with conform.nvim" })
    end,
}

