{ ... }: {
  # Wraps `nix develop` / `nix shell` / `nix-shell` to keep fish
  programs.nix-your-shell = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      # External tools
      lg = "lazygit";
      c = "bat";
      l = "eza -l";
      ll = "eza -la";
      lf = "lfcd";
      f = "fastfetch";
      b = "btop";
      p = "ps aux | rg -v '(ps aux|rg -)' | rg -i";

      # Openssl
      openssl_chain = "openssl crl2pkcs7 -nocrl -certfile /dev/stdin | openssl pkcs7 -print_certs -text -noout"; # To be piped (ex: cat)
      openssl_connect = "openssl s_client -showcerts -connect"; # ip:port

      # GNU tools
      d = "du -haxd1 . | sort -h";
      e = "$EDITOR";
      se = "sudoedit";
      tarc = "tar -czf";
      tarx = "tar -xf";
      lsof = "lsof +D"; # Recursive lookup
      df = "df -Th";
    };
    functions = {
      lfcd = ''
        # Terminal file manager (changing directory on exit)
        # `command` is needed in case `lfcd` is aliased to `lf`.
        # Quotes will cause `cd` to not change directory if `lf` prints nothing to stdout due to an error.
        cd "$(command lf -print-last-dir $argv)"
      '';
    };
    shellInit = ''
      fish_config theme choose catppuccin-mocha --color-theme=dark
    '';
  };
}
