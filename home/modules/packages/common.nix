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
    devenv
    direnv

    lazygit
    ngrok

    # finder
    ripgrep
    fd
    fzf
  ];
}
