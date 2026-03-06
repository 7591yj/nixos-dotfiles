{pkgs, ...}: {
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

  services.pipewire.extraConfig.pipewire."10-clock-rates" = {
    "context.properties" = {
      "default.clock.rate" = 96000;
      "default.clock.allowed-rates" = [44100 48000 88200 96000 176400 192000];
    };
  };

  services.pipewire.wireplumber.extraConfig."51-ifi-node" = {
    "monitor.alsa.rules" = [
      {
        matches = [{"node.description" = "iFi USB Audio SE Analog Stereo";}];
        actions."update-props" = {
          "audio.format" = "S32LE";
          "audio.rate" = 96000;
        };
      }
    ];
  };

  services.pipewire.wireplumber.extraConfig."10-bluez-aac" = {
    "monitor.bluez.properties" = {
      "bluez5.enable-aac" = true;
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-hw-volume" = true;
    };
  };
}
