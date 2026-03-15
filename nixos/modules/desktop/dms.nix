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
    enableAudioWavelength = false;
    enableCalendarEvents = false;
    enableClipboardPaste = true;

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
    compositor.name = config.mySystem.desktop.compositor;
    configHome = "/home/${config.mySystem.username}";
  };

  security.pam.services.dms-greeter.enableGnomeKeyring = true;
}
