return {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            basedpyright = { mason = false },
            pyright = { mason = false, enabled = false },
            pyrefly = { mason = false, enabled = false },
            ruff = {
                mason = false,
                enabled = false,
            },
        },
    },
}
