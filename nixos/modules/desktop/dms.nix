{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.dms-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = false;

    plugins = {
      dankBatteryAlerts.enable = true;
      dockerManager.enable = true;
    };
  };

  programs.dsearch = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };

  systemd.user.services.dsearch.serviceConfig.ExecStart = lib.mkForce [
    ""
    "${pkgs.dsearch}/bin/dsearch serve --socket"
  ];

  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/${config.mySystem.username}";
  };

  security.pam.services.dms-greeter.enableGnomeKeyring = true;
}
