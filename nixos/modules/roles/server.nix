{...}: {
  imports = [
    # Core system
    ../boot.nix
    ../nix.nix
    ../users.nix

    # Networking
    ../networking/server.nix
    ../tailscale.nix
    ../services/openssh.nix

    # Locale
    ../locale/base.nix

    # Applications
    ../packages/server.nix
    ../services/smartd.nix
  ];
}
