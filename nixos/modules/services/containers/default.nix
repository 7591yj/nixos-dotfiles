{ pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.containers.enable = true;

  networking.firewall.trustedInterfaces = [ "podman0" ];

  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
