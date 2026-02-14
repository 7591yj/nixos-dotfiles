{...}: {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      # Basic Settings
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*:RGB"
      set -g mouse on
      set -g set-clipboard on

      # vim pane nav
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -n M-h select-pane -L # alt
      bind -n M-j select-pane -D # alt
      bind -n M-k select-pane -U # alt
      bind -n M-l select-pane -R # alt

      # numbering
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # switch windows
      bind -n S-Left previous-window
      bind -n S-Right next-window
      bind -n M-1 select-window -t 1 # alt
      bind -n M-2 select-window -t 2 # alt
      bind -n M-3 select-window -t 3 # alt
      bind -n M-4 select-window -t 4 # alt
      bind -n M-5 select-window -t 5 # alt
      bind -n M-6 select-window -t 6 # alt

      # vim copy
      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # colors
      thm_bg="#222436"
      thm_fg="#c8d3f5"
      thm_cyan="#86e1fc"
      thm_black="#1b1d2b"
      thm_gray="#3a3f5a"
      thm_magenta="#c099ff"
      thm_pink="#ff757f"
      thm_red="#ff757f"
      thm_green="#c3e88d"
      thm_yellow="#ffc777"
      thm_blue="#82aaff"
      thm_orange="#ff9e64"
      thm_black4="#444a73"

      # status bar
      set -g status "on"
      set -g status-bg "''${thm_bg}"
      set -g status-justify "left"
      set -g status-left-length "100"
      set -g status-right-length "100"

      # panes
      set -g pane-border-style "fg=''${thm_gray}"
      set -g pane-active-border-style "fg=''${thm_blue}"

      # windows
      set -g window-status-activity-style "fg=''${thm_fg},bg=''${thm_bg},none"
      set -g window-status-separator ""
      set -g window-status-style "fg=''${thm_fg},bg=''${thm_bg},none"

      # messages
      set -g message-style "fg=''${thm_cyan},bg=''${thm_gray},align=centre"
      set -g message-command-style "fg=''${thm_cyan},bg=''${thm_gray},align=centre"

      # statusline - current window
      set -g window-status-current-format "#[fg=''${thm_blue},bg=''${thm_bg}] #I: #[fg=''${thm_magenta},bg=''${thm_bg}](✓) #[fg=''${thm_cyan},bg=''${thm_bg}]#(echo '#{pane_current_path}' | rev | cut -d'/' -f-2 | rev) #[fg=''${thm_magenta},bg=''${thm_bg}]"

      # statusline - other windows
      set -g window-status-format "#[fg=''${thm_blue},bg=''${thm_bg}] #I: #[fg=''${thm_fg},bg=''${thm_bg}]#W"

      # statusline - right side
      set -g status-right "#[fg=''${thm_blue},bg=''${thm_bg},nobold,nounderscore,noitalics]#[fg=''${thm_bg},bg=''${thm_blue},nobold,nounderscore,noitalics] #[fg=''${thm_fg},bg=''${thm_gray}] #W #{?client_prefix,#[fg=''${thm_magenta}],#[fg=''${thm_cyan}]}#[bg=''${thm_gray}]#{?client_prefix,#[bg=''${thm_magenta}],#[bg=''${thm_cyan}]}#[fg=''${thm_bg}] #[fg=''${thm_fg},bg=''${thm_gray}] #S "

      # statusline - left side (empty)
      set -g status-left ""

      # modes
      set -g clock-mode-colour "''${thm_blue}"
      set -g mode-style "fg=''${thm_blue} bg=''${thm_black4} bold"

      # reload
      unbind r
      bind r source-file $HOME/.config/tmux/tmux.conf
    '';
  };
}
