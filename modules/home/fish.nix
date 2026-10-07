{ ... }: {
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
        function lfcd --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
            # `command` is needed in case `lfcd` is aliased to `lf`.
            # Quotes will cause `cd` to not change directory if `lf` prints nothing to stdout due to an error.
            cd "$(command lf -print-last-dir $argv)"
        end
      '';
    };
    shellInit = ''
      fish_config theme choose catppuccin-mocha --color-theme=dark
    '';
  };
}
