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
      cl = "claude";
      oc = "opencode";
      c = "bat";
      l = "eza -l";
      ll = "eza -la";
      lf = "lfcd";
      f = "fastfetch";
      b = "btop";
      tl = "trash-list";
      te = "trash-empty";
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
      nixdiff = ''
        # Diff current system against a previous generation (default: 1 back, 2 = 2 back, ...)
        set -l gen 2
        if set -q argv[1]
          set gen (math $argv[1] + 1)
        end
        nix store diff-closures (ls -t1d /nix/var/nix/profiles/system-*-link | head -$gen | tail -1) /run/current-system
      '';
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
