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
    wget
    git
    tmux

    unzipNLS
    unrar
    p7zip

    usbutils

    upower
    evremap

    libsecret
    tailscale
    gh
    eza
    bat
    tree
    yazi-unwrapped

    ripgrep
    fd
    fzf

    neovim
    less
    fastfetchMinimal
    man
    man-pages

    mozc

    xwayland-satellite

    whitesur-cursors
    whitesur-gtk-theme
    whitesur-icon-theme

    polkit
    polkit_gnome
    ghostty
    brightnessctl
  ];
}
