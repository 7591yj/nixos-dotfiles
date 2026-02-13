{ pkgs, ... }:

{
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
  ];

  programs.nano.enable = false;
}
