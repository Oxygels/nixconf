{ lazyvim, pkgs, ... }:
{
  imports = [ lazyvim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;
    configFiles = ./config/nvim;
    extras = {
      coding.luasnip.enable = true;
      lang = {
        nix.enable = true;
        json.enable = true;
        markdown.enable = true;
        yaml.enable = true;
        go.enable = true;
        python.enable = true;
      };
    };

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

    # lazyvim-nix links catppuccin as "nvim" in its dev path, but LazyVim
    # names the plugin "catppuccin". Disable the stray "nvim" entry (it would
    # load catppuccin unconfigured) and point "catppuccin" at the Nix package.
    plugins.catppuccin = ''
      return {
        { "nvim", enabled = false },
        {
          "catppuccin/nvim",
          name = "catppuccin",
          dir = "${pkgs.vimPlugins.catppuccin-nvim}",
        },
      }
    '';

    # skip luasnip's runtime build (make); jsregexp comes from Nix
    plugins.luasnip = ''
      return { "L3MON4D3/LuaSnip", build = false }
    '';
  };

  programs.neovim.extraLuaPackages = ps: [ ps.jsregexp ];
}
