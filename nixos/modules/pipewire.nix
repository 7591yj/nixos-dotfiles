{ pkgs, ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    package = pkgs.pipewire;

    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;

    wireplumber.enable = true;
  };

  services.pipewire.wireplumber.extraConfig."10-bluez-aac" = {
    "monitor.bluez.properties" = {
    "bluez5.enable-aac" = true;
    "bluez5.enable-sbc-xq" = true;
    "bluez5.enable-hw-volume" = true;
    };
  };

}
