{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.tailscaleProxy;
  hostname = config.networking.hostName;
  certPath = "/var/lib/tailscale-certs";
  fqdn = "${hostname}.${cfg.tailnetDomain}";
  fetchTailscaleCerts = pkgs.writeShellScript "fetch-tailscale-certs" ''
    set -euo pipefail

    ${pkgs.coreutils}/bin/install -d -m0700 -o caddy -g caddy ${certPath}

    ${pkgs.tailscale}/bin/tailscale cert \
      --cert-file ${certPath}/${fqdn}.crt \
      --key-file ${certPath}/${fqdn}.key \
      ${fqdn}

    ${pkgs.tailscale}/bin/tailscale cert \
      --cert-file ${certPath}/jellyfin.${fqdn}.crt \
      --key-file ${certPath}/jellyfin.${fqdn}.key \
      jellyfin.${fqdn}

    ${pkgs.coreutils}/bin/chown caddy:caddy ${certPath}/*.crt ${certPath}/*.key
    ${pkgs.coreutils}/bin/chmod 600 ${certPath}/*.key
  '';
in {
  options.services.tailscaleProxy = {
    tailnetDomain = lib.mkOption {
      type = lib.types.str;
      description = "e.g. example.ts.net";
    };
  };

  config.services.caddy = {
    enable = true;

    virtualHosts."jellyfin.${fqdn}" = {
      extraConfig = ''
        reverse_proxy localhost:8096

        tls ${certPath}/jellyfin.${fqdn}.crt ${certPath}/jellyfin.${fqdn}.key
      '';
    };
  };

  config.systemd.services.tailscale-certs = {
    description = "Fetch Tailscale HTTPS certificates";
    after = [
      "network-online.target"
      "tailscaled.service"
    ];
    wants = [
      "network-online.target"
      "tailscaled.service"
    ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = fetchTailscaleCerts;
      ExecStartPost = "${pkgs.systemd}/bin/systemctl try-reload-or-restart caddy.service";
    };
  };

  config.systemd.timers.tailscale-certs = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  config.systemd.tmpfiles.rules = [
    "d ${certPath} 0700 caddy caddy -"
  ];

  config.systemd.services.caddy = {
    after = ["tailscale-certs.service"];
    wants = ["tailscale-certs.service"];
  };

  config.networking.firewall.trustedInterfaces = ["tailscale0"];
}
