{
  lib,
  ...
}: {
  imports = [
    ./niri.nix
  ];

  options.mySystem.desktop.compositor = lib.mkOption {
    type = lib.types.enum ["niri"];
    description = "Wayland compositor";
  };
}
