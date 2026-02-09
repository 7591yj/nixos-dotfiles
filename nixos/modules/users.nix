{ config, lib, ... }:

let
  username = config.mySystem.username;
in
{
  options.mySystem.username = lib.mkOption {
    type = lib.types.str;
    default = "u7591yj";
    description = "Primary user account name";
  };

  config = {
    users.users.root.hashedPassword = "!";
    users.users.${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "libvirtd" ];
    };
  };
}
