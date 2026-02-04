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
    alacritty-graphics

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

    # toolchain
    diffutils
    pv
    duf

    # network
    tailscale
    rsync
    wget

    # archives
    unzipNLS
    unrar
    p7zip
    yazi-unwrapped
    file

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
   
    # theme
    whitesur-cursors
    whitesur-gtk-theme
    whitesur-icon-theme
  ];
}
