{
  config,
  lib,
  ...
}: {
  hardware.bluetooth.enable = true;
  services.blueman.enable = lib.mkIf (config.mySystem.displayServer == "x11") true;
}
