{ inputs, ... }:

{
  imports = [
    # Core system
    ../boot.nix
    ../nix.nix
    ../users.nix

    # Networking
    ../networking/desktop.nix

    # Locale (base only - input method is optional at host level)
    ../locale/base.nix

    # Desktop base (portals, keyring, polkit, dms)
    ../desktop/base.nix

    # Audio/Media
    ../pipewire.nix
    ../bluetooth.nix

    # Display server - Wayland/Niri
    ../desktop/wayland-niri.nix

    # Applications
    ../packages.nix
    ../fonts.nix
    ../printing.nix
    ../flatpak.nix
    ../tailscale.nix

    # External
    inputs.dms-plugin-registry.modules.default
  ];
}
