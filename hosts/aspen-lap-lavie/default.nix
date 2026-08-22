{
  config,
  lib,
  pkgs,
  ...
}:
{
  mySystem.desktop.compositor = "niri";

  # NOTE: This disk predates disko.
  # LUKS and ESP are referenced by UUID so they are not affected by the
  # missing GPT partition labels disko would normally set
  boot.initrd.luks.devices."luksroot" = {
    device = "/dev/disk/by-uuid/8f4e044b-3d7a-4bfb-b8bc-eab9fdb36645";
    allowDiscards = true;
    preLVM = true;
  };
  fileSystems."/boot".device = lib.mkForce "/dev/disk/by-uuid/619C-5E4C";

  sops.secrets.icon = {
    format = "binary";
    sopsFile = ../../secrets/icon.png;
    owner = config.mySystem.username;
  };

  mySystem.fastfetch.logoPath = config.sops.secrets.icon.path;

  # Workaround Intel bl getting stuck during btintel_pcie firmware init
  systemd.services.intel-bluetooth-pcie-reset = {
    description = "Reset Intel Bluetooth PCIe controller";
    before = [ "bluetooth.service" ];
    requiredBy = [ "bluetooth.service" ];
    path = [ pkgs.coreutils ];

    serviceConfig = {
      Type = "oneshot";
    };

    script = ''
      if [ -e /sys/bus/pci/devices/0000:00:14.7/remove ]; then
        echo 1 > /sys/bus/pci/devices/0000:00:14.7/remove
        sleep 1
      fi

      echo 1 > /sys/bus/pci/rescan
      sleep 3
    '';
  };

  # BlueZ can start before the recovered controller is fully usable on this
  # machine. A single delayed restart after boot matches the manual sequence
  # that makes the adapter appear.
  systemd.services.intel-bluetooth-bluez-settle = {
    description = "Restart BlueZ after Intel Bluetooth controller settles";
    after = [ "bluetooth.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.coreutils
      pkgs.systemd
    ];

    serviceConfig = {
      Type = "oneshot";
    };

    script = ''
      sleep 5
      systemctl restart bluetooth.service
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
