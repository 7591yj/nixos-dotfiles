{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      whitesur-icon-theme = prev.whitesur-icon-theme.override {
        alternativeIcons = true;
      };
    })
  ];

  programs.dconf.enable = true;

  stylix = {
    enable = true;
    polarity = "dark";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night.yaml";

    fonts = {
      serif = {
        package = pkgs.plemoljp-nf;
        name = "PlemolJP35 Console NF";
      };

      sansSerif = {
        package = pkgs.plemoljp-nf;
        name = "PlemolJP35 Console NF";
      };

      monospace = {
        package = pkgs.plemoljp-nf;
        name = "PlemolJP35 Console NF";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        terminal = 12;
      };
    };

    cursor = {
      package = pkgs.whitesur-cursors;
      name = "WhiteSur-cursors";
      size = 24;
    };

    opacity = {
      applications = 0.9;
      desktop = 0.9;
      popups = 0.9;
      terminal = 0.9;
    };

    icons = {
      enable = true;
      package = pkgs.whitesur-icon-theme;
      light = "WhiteSur";
      dark = "WhiteSur-dark";
    };
  };

  home-manager.sharedModules = [
    ({
      lib,
      config,
      ...
    }: {
      home.file."${config.home.homeDirectory}/.Xresources".force = true;
      xdg.configFile."gtk-3.0/settings.ini".force = true;
      xdg.configFile."gtk-3.0/gtk.css".force = true;
      xdg.configFile."gtk-4.0/settings.ini".force = true;
      xdg.configFile."qt5ct/qt5ct.conf".force = true;
      xdg.configFile."qt6ct/qt6ct.conf".force = true;

      home.sessionVariables = {
        QT_QPA_PLATFORMTHEME = lib.mkForce "gtk3";
      };

      dconf.settings."org/gnome/desktop/interface" = {
        color-scheme = lib.mkForce "prefer-dark";
        cursor-theme = lib.mkForce "WhiteSur-cursors";
        cursor-size = lib.mkForce (lib.gvariant.mkInt32 24);
      };
    })
  ];
}
