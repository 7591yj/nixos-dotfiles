{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.dms-shell = {
    enable = true;
    quickshell.package =
      inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;

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
    quickshell.package =
      inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
  };

  security.pam.services.dms-greeter.enableGnomeKeyring = true;
}
