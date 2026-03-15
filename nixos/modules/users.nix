{
  config,
  lib,
  ...
}: let
  username = config.mySystem.username;
in {
  options.mySystem.username = lib.mkOption {
    type = lib.types.str;
    default = "u7591yj";
    description = "Primary user account name";
  };

  options.mySystem.displayServer = lib.mkOption {
    type = lib.types.enum ["wayland" "x11"];
    default = "wayland";
    description = "Display server to use";
  };

  config = {
    users.users.root.hashedPassword = "!";
    users.users.${username} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };
}
