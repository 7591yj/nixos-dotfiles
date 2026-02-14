{pkgs, ...}: {
  home.packages = with pkgs; [
    # version control
    git
    gh

    # shell
    zoxide
    eza
    tmux
    bat
    tree
    less

    lazygit
    ngrok

    # finder
    ripgrep
    fd
    fzf

    # system info
    fastfetch
  ];
}
