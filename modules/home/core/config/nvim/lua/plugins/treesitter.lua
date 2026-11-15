return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = true,
            },
            ensure_installed = {
                "bash",
                "c",
                "diff",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "printf",
                "python",
                "query",
                "regex",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
            },
        },
    },
    {
        -- Parsers are pre-built by Nix and linked into stdpath("data")/site
        -- (see modules/home/core/neovim.nix). Replace LazyVim's runtime
        -- installer (which would need a C compiler and write into the nix
        -- store) with a clear message about missing parsers.
        --
        -- LazyDone fires before any LazyFile/VeryLazy plugin loads, so the
        -- overrides are in place before LazyVim's treesitter config runs.
        "nvim-treesitter/nvim-treesitter",
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyDone",
                once = true,
                callback = function()
                    local ok, ts = pcall(require, "lazyvim.util.treesitter")
                    if not ok or not ts then
                        return
                    end
                    -- Healthcheck: parsers come from Nix, so requirements are met
                    ts.check = function()
                        return true, { ["nix"] = true }
                    end
                    -- Called by LazyVim when ensure_installed parsers are missing
                    ts.build = function()
                        local plugin = require("lazy.core.config").plugins["nvim-treesitter"]
                        local opts = plugin and require("lazy.core.plugin").values(plugin, "opts", false) or {}
                        local missing = vim.tbl_filter(function(lang)
                            return not ts.have(lang)
                        end, opts.ensure_installed or {})
                        if #missing == 0 then
                            return
                        end
                        vim.notify(
                            table.concat({
                                "Treesitter parsers are managed by Nix; runtime installation is disabled.",
                                "",
                                "Missing parsers: `" .. table.concat(missing, "`, `") .. "`",
                                "",
                                "Add them to `parserLangs` in modules/home/core/neovim.nix.",
                            }, "\n"),
                            vim.log.levels.WARN,
                            { title = "nixconf" }
                        )
                    end
                end,
            })
        end,
    },
}
