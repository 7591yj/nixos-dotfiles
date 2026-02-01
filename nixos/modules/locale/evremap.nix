{ pkgs, ... }:

{
  environment.etc."evremap.toml".source = ../../../config/evremap.toml;
  systemd.services.evremap = {
    description = "evremap";
    serviceConfig = {
      ExecStart = "${pkgs.evremap}/bin/evremap remap /etc/evremap.toml";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };
  services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="input", ENV{ID_INPUT_KEYBOARD}=="1", TAG+="systemd", ENV{SYSTEMD_WANTS}="evremap.service"
    '';
}
