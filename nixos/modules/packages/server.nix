{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # version control
    git

    # shell
    tmux
    eza
    bat
    less

    # finder
    ripgrep
    fd
    fzf

    # network
    rsync
    wget
    curl
    tailscale
  ];
}
