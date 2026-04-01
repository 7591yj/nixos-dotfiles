{...}: {
  imports = [
    # Core system
    ../boot.nix
    ../../shared/nix.nix
    ../users.nix

    # Networking
    ../networking/server.nix
    ../tailscale.nix
    ../services/openssh.nix

    # Locale
    ../locale/base.nix

    # Applications
    ../../shared/packages/common.nix
    ../packages/server.nix
    ../services/smartd.nix

    ../../shared/programs/bash.nix
    ../../shared/programs/git.nix
    ../../shared/programs/neovim/default.nix
    ../../shared/programs/starship/default.nix
    ../../shared/programs/tmux/default.nix
    ../../shared/programs/yazi/default.nix
  ];
}
