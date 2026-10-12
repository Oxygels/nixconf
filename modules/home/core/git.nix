{ lib, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      # mkDefault lets hosts override identity with a plain assignment
      user = {
        name = lib.mkDefault "Oxy";
        email = lib.mkDefault "39919597+Oxygels@users.noreply.github.com";
      };
      credential.helper = "cache --timeout=3600";
      # Push tags at the same time than commits
      push.followTags = true;
      pull.rebase = true;
      # Remove local branches not existing on remote
      # WARNING: Make sure you always create your branches (usually from issues) on Github
      remote.origin.prune = true;
      alias = {
        l = "log --graph --oneline";
        a = "add";
        d = "diff";
        ds = "diff --staged";
        dl = "diff @~";
        s = "status";
        st = "stash";
        sp = "stash pop";
        sl = "stash list";
        c = "commit";
        ck = "checkout";
        cm = "commit -m";
        p = "pull";
        pu = "push";
        pt = "push --tag";
        rmc = "rm --cached";
        t = "tag --sort v:refname"; # -v:refname to invert the sort
        ap = "apply --3way";
      };
    };
  };
}
