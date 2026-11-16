{ ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    extraConfig = ''
      set -g mouse on

      # Truecolor passthrough through Windows Terminal
      set -as terminal-features ",xterm-256color:RGB"

      # Clipboard: OSC 52 plus Windows clipboard via clip.exe (WSL interop)
      set -s set-clipboard on
      set -s copy-command clip.exe

      bind -n M-C-Left previous-window
      bind -n M-C-Right next-window

      set -g status on
      set -g status-interval 5
      set -g status-position bottom
      set -g status-justify left
      set -g status-style "bg=#1f2335,fg=#a9b1d6"
      set -g status-left "#[fg=#1a1b26,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#1f2335] "
      set -g status-left-length 40
      set -g status-right "#{?client_prefix,#[fg=#1a1b26#,bg=#f7768e#,bold] PREFIX ,}#[fg=#1a1b26,bg=#7dcfff,bold] %H:%M "
      set -g window-status-current-format "#[fg=#1a1b26,bg=#7dcfff,bold] #I:#W "
      set -g window-status-format "#[fg=#565f89,bg=#1f2335] #I:#W "
      set -g window-status-separator ""
      set -g pane-border-style "fg=#414868"
      set -g pane-active-border-style "fg=#7aa2f7"
      set -g pane-border-lines heavy
      setw -g monitor-activity on
      set -g window-status-activity-style "fg=#e0af68,bg=#1f2335"
      set -g mode-style "bg=#283457,fg=#c0caf5"
      set -g message-style "bg=#7aa2f7,fg=#1a1b26,bold"
    '';
  };
}
