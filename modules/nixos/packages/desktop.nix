{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    [
      # developer
      zed-editor
      code-cursor-fhs
      unityhub

      # terminal
      kitty

      # productivity
      anki
      (logseq.override { electron = electron_39; })
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
      xwayland-satellite
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
    ]
    ++ [
      inputs.t3code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
    ];

  programs.nano.enable = false;
}
