{pkgs, ...}: {
  home.packages = with pkgs; [
    # version control
    git
    gh

    # shell
    zoxide
    eza
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
