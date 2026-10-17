-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Vim general settings
local opt = vim.opt
vim.opt.autochdir = true -- Switch the cwdir to the file/buffer currently open, useful for the "recent file" feature

vim.filetype.add({
    filename = {
        ["kitty.conf"] = "kitty",
    },
})

-- Indent settings
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.cindent = true

-- Visual settings
opt.wrap = true

-- LSP settings
vim.g.lazyvim_python_lsp = "basedpyright"
