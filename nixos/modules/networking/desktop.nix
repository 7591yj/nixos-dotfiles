{ ... }:

{
  networking.networkmanager = {
    enable = true;
    wifi.scanRandMacAddress = true;
    dns = "systemd-resolved";
  };

  # Split DNS: local network DNS for general queries,
  # Tailscale DNS only for Tailscale domains.
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
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
