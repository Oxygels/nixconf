-- Nix-specific overrides: LSP tools and treesitter grammars are provided by
-- Nix (see modules/home/core/neovim.nix), so Mason is disabled.
return {
    { "mason-org/mason.nvim", enabled = false },
    { "mason-org/mason-lspconfig.nvim", enabled = false },
    { "jay-babu/mason-nvim-dap.nvim", enabled = false },
    -- jsregexp is provided by nix; skip the make-based build
    { "L3MON4D3/LuaSnip", build = false },
}
