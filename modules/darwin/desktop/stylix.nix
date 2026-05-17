{
  pkgs,
  ...
}:
{
  home-manager.sharedModules = [
    ({ config, ... }: {
      gtk.gtk4.theme = config.gtk.theme;
    })
  ];

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

    opacity = {
      applications = 0.9;
      desktop = 0.9;
      popups = 0.9;
      terminal = 0.9;
    };
  };
}
