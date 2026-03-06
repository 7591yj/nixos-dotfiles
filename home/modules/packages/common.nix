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

    lazygit
    ngrok

    # finder
    ripgrep
    fd
    fzf
  ];
}
