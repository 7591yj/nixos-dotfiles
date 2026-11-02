{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.dux-shell = {
    enable = true;
    quickshell.package = pkgs.quickshell;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    plugins.dockerManager.enable = true;
  };

  environment.systemPackages = [ pkgs.vicinae ];

  services.displayManager.dux-greeter = {
    enable = true;
    compositor.name = config.mySystem.desktop.compositor;
    configHome = "/home/${config.mySystem.username}";
  };

  security.pam.services.dms-greeter.enableGnomeKeyring = true;
}
