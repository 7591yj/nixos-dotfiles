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
      claude-code

      # terminal
      kitty

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

      # viewer
      loupe
      papers
      readest
      sioyek

      # media
      celluloid
      jellyfin-desktop
      tauon
      tidal-hifi

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

      helium
    ]
    ++ [
      inputs.codex-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.t3code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  programs.nano.enable = false;
}
