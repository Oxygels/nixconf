{ pkgs, lib, ... }:
let
  # Treesitter grammars pre-built by Nix, linked into stdpath("data")/site,
  # which is on the runtimepath (and is nvim-treesitter's default install
  # dir). This keeps nvim-treesitter from compiling parsers at runtime, so
  # no C compiler is needed. Grammar revisions are pinned by
  # nvim-treesitter itself. Everything else plugin-related is managed by
  # lazy.nvim (see config/nvim/init.lua).
  parserLangs = [
    "bash"
    "c"
    "diff"
    "dtd"
    "go"
    "gomod"
    "gosum"
    "gowork"
    "html"
    "javascript"
    "jsdoc"
    "json"
    "json5"
    "lua"
    "luadoc"
    "luap"
    "markdown"
    "markdown_inline"
    "ninja"
    "nix"
    "printf"
    "python"
    "query"
    "regex"
    "rst"
    "toml"
    "tsx"
    "typescript"
    "vim"
    "vimdoc"
    "xml"
    "yaml"
  ];

  treesitterParsers = pkgs.runCommand "nvim-treesitter-parsers" { } ''
    mkdir -p $out
    ${lib.concatStringsSep "\n" (
      map (
        lang:
        "ln -s ${pkgs.vimPlugins.nvim-treesitter-parsers.${lang}}/parser/${lang}.so $out/${lang}.so"
      ) parserLangs
    )}
  '';
in
{
  programs.neovim = {
    enable = true;
    # jsregexp for LuaSnip regex transforms. Pinned because building it
    # (LuaSnip's make step) needs a C compiler, which NixOS doesn't provide by
    # default; the LuaSnip build is disabled in lua/plugins/nixpkgs.lua.
    extraLuaPackages = ps: [ ps.jsregexp ];
    # LSP servers, formatters and linters, available on the wrapped nvim's PATH
    extraPackages = with pkgs; [
      # nix
      statix
      nixd
      nixfmt
      # go
      go
      gopls
      gofumpt
      gotools
      golangci-lint
      delve
      gomodifytags
      impl
      # python
      python3
      basedpyright
      # json / yaml
      vscode-langservers-extracted
      yaml-language-server
      # markdown
      marksman
      markdownlint-cli2
      # lua
      lua-language-server
      stylua
    ];
  };

  xdg.dataFile = {
    # Pre-built treesitter grammars
    "nvim/site/parser".source = treesitterParsers;
  };

  # Deploy config files individually so ~/.config/nvim stays a real directory
  # (lazy.nvim writes lazy-lock.json and lazyvim.json into it).
  xdg.configFile = {
    "nvim/init.lua".source = ./config/nvim/init.lua;
    "nvim/lua".source = ./config/nvim/lua;
    "nvim/snippets".source = ./config/nvim/snippets;
  };
}
