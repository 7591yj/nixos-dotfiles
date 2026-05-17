{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # version control
    git
    gh
    lazygit

    # file management
    bat
    eza
    fd
    fzf
    ripgrep
    tree

    # network
    curl
    rsync
    tailscale
    wget

    # nix
    devenv
    direnv
    nh

    # misc
    zoxide
    zrok
  ];
}
