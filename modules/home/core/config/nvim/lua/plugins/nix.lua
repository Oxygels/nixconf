return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                nil_ls = { enabled = false, mason = false },
                nixd = {
                    mason = false,
                    settings = {
                        nixd = {
                            nixpkgs = {
                                expr = "import <nixpkgs> { }",
                            },
                        },
                    },
                },
            },
        },
    },
}
