{
  config,
  lib,
  pkgs,
  ...
}: let
  isWayland = config.mySystem.displayServer == "wayland";
in {
  programs.dms-shell = lib.mkIf isWayland {
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

  programs.dsearch = lib.mkIf isWayland {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };

  systemd.user.services.dsearch.serviceConfig.ExecStart = lib.mkIf isWayland (lib.mkForce [
    ""
    "${pkgs.dsearch}/bin/dsearch serve --socket"
  ]);

  services.displayManager.dms-greeter = lib.mkIf isWayland {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/${config.mySystem.username}";
  };

  security.pam.services.dms-greeter.enableGnomeKeyring = lib.mkIf isWayland true;
}
