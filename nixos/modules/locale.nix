{ pkgs, ... }:

{
  time.timeZone = "Asia/Tokyo";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-hangul ];
    fcitx5.waylandFrontend = true;
  };

  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  environment.etc."evremap.toml".source = ../../config/evremap.toml;
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
