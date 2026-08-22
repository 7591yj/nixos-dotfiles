{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # developer
    zed-editor

    # terminal
    ghostty

    # productivity
    anki
    (logseq.override {
      electron_39 = electron_41-bin;
    })
    (callPackage ../../../pkgs/onlyoffice-desktopeditors.nix {
      extraFonts = [ ipaexfont ];
    })

    # communication
    discord
    element-desktop
    telegram-desktop
    valent

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
    (callPackage ../../../pkgs/pen.nix { })
    (callPackage ../../../pkgs/sticker-smith.nix { })
  ];

  programs.nano.enable = false;
}
