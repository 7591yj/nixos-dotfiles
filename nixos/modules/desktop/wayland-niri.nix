{
  config,
  lib,
  ...
}:
lib.mkIf (config.mySystem.displayServer == "wayland") {
  programs.niri.enable = true;
  programs.xwayland.enable = true;
}
