{ ... }:

{
  networking.networkmanager = {
    enable = true;
    wifi.scanRandMacAddress = true;
    dns = "systemd-resolved";
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "false";
      DNS = [ "1.1.1.1" "8.8.8.8" ];
      FallbackDNS = [ "9.9.9.9" "8.8.4.4" ];
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
