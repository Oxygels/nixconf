return {
    "neovim/nvim-lspconfig",
    opts = {
        -- make sure mason installs the server
        servers = {
            yamlls = {
                settings = {
                    redhat = { telemetry = { enabled = false } },
                    yaml = {
                        keyOrdering = false,
                        format = {
                            enable = true,
                            singleQuote = true,
                        },
                        validate = true,
                    },
                },
            },
        },
    },
}
