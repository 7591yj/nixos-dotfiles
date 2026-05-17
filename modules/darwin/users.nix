{
  config,
  lib,
  ...
}:
let
  username = config.mySystem.username;
in
{
  options.mySystem.username = lib.mkOption {
    type = lib.types.str;
    default = "7591yj";
    description = "Primary user account name";
  };

  config = {
    system.primaryUser = lib.mkDefault username;
    users.users.${username}.home = lib.mkDefault "/Users/${username}";
  };
}
