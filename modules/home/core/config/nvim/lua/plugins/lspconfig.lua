return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                -- Don't let nvim-lspconfig manage roslyn_ls because it's managed by roslyn.nvim
                roslyn_ls = {
                    enabled = false,
                },
            },
        },
    },
}
