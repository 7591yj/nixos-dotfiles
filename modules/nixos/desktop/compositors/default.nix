{
  config,
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

  config = {
    assertions = [
      {
        assertion = config.services.displayManager.dms-greeter.compositor.name == config.mySystem.desktop.compositor;
        message = "services.displayManager.dms-greeter.compositor.name must match mySystem.desktop.compositor.";
      }
    ];
  };
}
