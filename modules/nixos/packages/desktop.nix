{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # developer
    zed-editor
    unityhub

    # terminal
    ghostty

    # productivity
    anki
    logseq
    (callPackage ../../../pkgs/onlyoffice-desktopeditors.nix {
      extraFonts = [ ipaexfont ];
    })

    # communication
    element-desktop
    legcord
    telegram-desktop
    valent
    zoom-us

    # viewer
    loupe
    papers
    readest
    sioyek

    # media
    celluloid
    ffmpeg
    jellyfin-desktop
    tauon
    tidal-hifi
    yt-dlp

    # gaming
    steam

    # file management
    btrfs-assistant
    localsend
    nautilus

    # graphics
    ffmpegthumbnailer
    imagemagick
    libopenraw
    snapshot
    krita

    # security
    libsecret
    proton-pass
    seahorse

    # utils
    diffutils
    duf
    file
    p7zip
    pv
    unzipNLS
    unrar
    usbutils

    (callPackage ../../../pkgs/astra.nix { })
    (callPackage ../../../pkgs/pencil.nix { })
    (callPackage ../../../pkgs/sticker-smith.nix { })
  ];

  programs.nano.enable = false;
}
