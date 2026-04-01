{inputs, ...}: {
  imports = [
    # Core system
    ../boot.nix
    ../../shared/nix.nix
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

    # Wayland compositor selection
    ../desktop/compositors/default.nix

    # Applications
    ../../shared/packages/common.nix
    ../packages/desktop.nix
    ../fonts.nix
    ../printing.nix
    ../flatpak.nix
    ../tailscale.nix

    ../desktop/fastfetch.nix
    ../desktop/mime.nix
    ../desktop/pwa.nix

    ../../shared/programs/bash.nix
    ../../shared/programs/git.nix
    ../../shared/programs/neovim/default.nix
    ../../shared/programs/starship/default.nix
    ../../shared/programs/tmux/default.nix
    ../../shared/programs/yazi/default.nix

    # External
    inputs.dms-plugin-registry.modules.default
  ];
}
