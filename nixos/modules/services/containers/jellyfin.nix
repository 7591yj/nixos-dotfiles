{
  config,
  pkgs,
  ...
}: let
  tailnetDomain = config.services.tailscaleProxy.tailnetDomain;
in {
  users.users.jellyfin = {
    isSystemUser = true;
    group = "jellyfin";
    uid = 1100;
  };
  users.groups.jellyfin.gid = 1100;

  virtualisation.oci-containers = {
    backend = "podman";
    containers.jellyfin = {
      image = "docker.io/jellyfin/jellyfin:latest";
      autoStart = true;

      extraOptions = [
        "--network=host"
        "--device=/dev/dri:/dev/dri"
      ];

      environment = {
        JELLYFIN_PublishedServerUrl = "https://jellyfin.${config.networking.hostName}.${tailnetDomain}";
      };

      volumes = [
        "/var/lib/jellyfin/config:/config"
        "/var/lib/jellyfin/cache:/cache"
        "/tank/media:/media:ro"
      ];

      user = "1100:1100";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/jellyfin 0755 jellyfin jellyfin -"
    "d /var/lib/jellyfin/config 0755 jellyfin jellyfin -"
    "d /var/lib/jellyfin/cache 0755 jellyfin jellyfin -"
  ];

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-compute-runtime
  ];
}
