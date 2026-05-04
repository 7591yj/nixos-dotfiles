{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.dms-shell = {
    enable = true;
    quickshell.package = pkgs.quickshell;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = false;
    enableCalendarEvents = false;
    enableClipboardPaste = false;

    plugins = {
      dankBatteryAlerts.enable = true;
      dockerManager.enable = true;
    };
  };

  environment.systemPackages = [ pkgs.vicinae ];

  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = config.mySystem.desktop.compositor;
    configHome = "/home/${config.mySystem.username}";
  };

  security.pam.services.dms-greeter.enableGnomeKeyring = true;
}
