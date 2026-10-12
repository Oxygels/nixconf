{ ... }: {
  home.sessionVariables = {
    EDITOR = "nvim";
    FZF_DEFAULT_COMMAND = "fd --type f --strip-cwd-prefix --hidden --exclude .git";
  };
}
