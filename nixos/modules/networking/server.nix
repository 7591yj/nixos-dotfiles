{ ... }:

{
  networking.useNetworkd = true;
  systemd.network.enable = true;

  networking.firewall.enable = true;
}
