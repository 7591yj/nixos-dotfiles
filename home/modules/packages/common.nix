{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # version control
    git
    gh

    # shell
    blesh
    starship

    zoxide
    eza
    tmux
    bat
    tree
    less

    lazygit
    ngrok

    # finder
    yazi-unwrapped
    ripgrep
    fd
    fzf

    # system info
    fastfetchMinimal
  ];
}
