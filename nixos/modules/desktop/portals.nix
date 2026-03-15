{
  config,
  lib,
  pkgs,
  ...
}: {
  xdg.portal = {
    enable = true;
    config =
      if config.mySystem.displayServer == "x11"
      then {
        common.default = "gtk";
        OXWM.default = "gtk";
      }
      else {
        common.default = "*";
      };
    extraPortals = with pkgs;
      [xdg-desktop-portal-gtk]
      ++ lib.optionals (config.mySystem.displayServer == "wayland") [
        xdg-desktop-portal-gnome
      ];
  };
}
