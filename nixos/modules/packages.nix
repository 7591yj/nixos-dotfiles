{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      whitesur-icon-theme = prev.whitesur-icon-theme.override {
        alternativeIcons = true;
      };
    })
  ];
  environment.systemPackages = with pkgs; [
    # toolchain
    diffutils
    pv
    duf

    # editor
    neovim

    # network
    tailscale
    rsync
    wget

    # archives
    unzipNLS
    unrar
    p7zip
    file

    # usb
    usbutils

    # graphics
    xwayland-satellite

    # security
    libsecret
    polkit
    polkit_gnome
  ];
}
