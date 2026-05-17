{
  config,
  lib,
  ...
}:
{
  networking.hostName = "cypress-lap-mbp";

  sops.secrets.icon = {
    format = "binary";
    sopsFile = ../../secrets/icon.png;
    owner = config.mySystem.username;
  };

  mySystem.fastfetch.logoPath = config.sops.secrets.icon.path;

  system.stateVersion = 6;
}
