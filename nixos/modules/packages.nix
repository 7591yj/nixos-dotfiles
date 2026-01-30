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
    # version control
    git
    gh

    # shell
    eza
    tmux
    bat
    tree
    less

    # finder
    ripgrep
    fd
    fzf

    # editor
    neovim

    # system info
    fastfetchMinimal
    man
    man-pages

    # dev toolchain
    cmakeWithGui
    ninja
    diffutils
    pv
    duf

    # language tooling
    nodejs
    pnpm
    bun
    uv

    # network
    tailscale
    rsync
    wget

    # archives
    unzipNLS
    unrar
    p7zip
    yazi-unwrapped

    # usb
    usbutils

    # power
    upower
    brightnessctl

    # graphics
    xwayland-satellite

    # media
    gst_all_1.gst-plugins-rs

    # input
    evremap
    mozc

    # security
    libsecret
    polkit
    polkit_gnome
    ghostty

    # theme
    whitesur-cursors
    whitesur-gtk-theme
    whitesur-icon-theme
  ];
}
