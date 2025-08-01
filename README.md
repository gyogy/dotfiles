#TROUBLESHOOTING

    +curl: (92) HTTP/2 stream 1 was not closed cleanly: PROTOCOL_ERROR (err 1)
    In `~/.local/share/nvim/lazy/plenary.nvim/lua/plenary` add `  opts.http_version = "HTTP/1.1"`
below `parse.request = function(opts)` to force http_version and bypass this error.

