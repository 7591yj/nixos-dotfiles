{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  isX11 = osConfig.mySystem.displayServer == "x11";
in {
  home.packages = with pkgs;
    [
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
    ]
    ++ lib.optionals isX11 [
      rofi
      clipmenu
      feh
      networkmanagerapplet
      brightnessctl
      playerctl
      pamixer
      maim
      xclip
      xdotool
      (pkgs.callPackage ../../../pkgs/st-kitty.nix {})
    ];

  systemd.user.services.clipmenud = lib.mkIf isX11 {
    Unit = {
      Description = "Clipboard history daemon for clipmenu";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.clipmenu}/bin/clipmenud";
      Restart = "on-failure";
    };

    Install.WantedBy = ["graphical-session.target"];
  };
}
