{config, pkgs, ...}: {
  users.users.${config.mySystem.username}.extraGroups = ["networkmanager"];
  networking.networkmanager = {
    enable = true;
    wifi.scanRandMacAddress = true;
    dns = "systemd-resolved";
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "false";
      FallbackDNS = ["1.1.1.1" "8.8.8.8"];
    };
  };

  # Connectivity check for captive portal detection
  networking.networkmanager.settings.connectivity = {
    uri = "http://nmcheck.gnome.org/check_network_status.txt";
    response = "NetworkManager is online";
    interval = 300;
  };

  # Disable WiFi power saving to prevent packet loss
  networking.networkmanager.wifi.powersave = false;
}
