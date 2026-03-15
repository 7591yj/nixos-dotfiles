{inputs, ...}: {
  imports = [
    # Core system
    ../boot.nix
    ../nix.nix
    ../users.nix

    # Secrets
    ../sops.nix

    # Networking
    ../networking/desktop.nix

    # Locale (base only - input method is optional at host level)
    ../locale/base.nix

    # Desktop base (portals, keyring, polkit, dms)
    ../desktop/base.nix
    ../desktop/stylix.nix

    # Audio/Media
    ../pipewire.nix
    ../bluetooth.nix

    # Storage
    ../storage/gvfs.nix

    # Display server (controlled by mySystem.displayServer)
    ../desktop/wayland-niri.nix
    ../desktop/x11.nix

    # Applications
    ../packages/desktop.nix
    ../fonts.nix
    ../printing.nix
    ../flatpak.nix
    ../tailscale.nix

    # External
    inputs.dms-plugin-registry.modules.default
  ];
}
