{
  config,
  lib,
  ...
}: lib.mkIf (config.mySystem.desktop.compositor == "niri") {
  programs.niri.enable = true;
  programs.xwayland.enable = true;
}
