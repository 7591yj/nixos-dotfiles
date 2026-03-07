{pkgs, ...}: {
  home.packages = with pkgs; [
    # terminal
    alacritty-graphics

    # editor
    zed-editor

    # docs
    obsidian
    onlyoffice-desktopeditors
    anki-bin
    sioyek

    # communication
    telegram-desktop
    element-desktop
    legcord

    # entertainment
    tauon
    jellyfin-desktop
    steam
    # kdePackages.kdenlive

    # gtk
    nautilus
    celluloid
    loupe
    papers
    snapshot
    seahorse

    # misc
    proton-pass
    btrfs-assistant
    valent
    localsend
    ffmpegthumbnailer
    imagemagick
    libopenraw
    claude-code

    # theme
    whitesur-cursors
    whitesur-gtk-theme
    whitesur-icon-theme
  ];
}
