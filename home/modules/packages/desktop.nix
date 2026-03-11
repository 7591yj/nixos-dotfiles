{pkgs, ...}: {
  home.packages = with pkgs; [
    # terminal
    kitty

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
    tidal-hifi
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
  ];
}
