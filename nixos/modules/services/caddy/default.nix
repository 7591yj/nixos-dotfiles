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

        tls ${certPath}/${fqdn}.crt ${certPath}/${fqdn}.key
      '';
    };
  };

  config.systemd.services.tailscale-certs = {
    description = "Fetch Tailscale HTTPS certificates";
    after = ["tailscaled.service"];
    wants = ["tailscaled.service"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "fetch-tailscale-certs" ''
        ${pkgs.tailscale}/bin/tailscale cert \
          --cert-file ${certPath}/${fqdn}.crt \
          --key-file ${certPath}/${fqdn}.key \
          ${fqdn}

        ${pkgs.tailscale}/bin/tailscale cert \
          --cert-file ${certPath}/jellyfin.${fqdn}.crt \
          --key-file ${certPath}/jellyfin.${fqdn}.key \
          jellyfin.${fqdn}

        chown caddy:caddy ${certPath}/*.crt ${certPath}/*.key
        chmod 600 ${certPath}/*.key
      '';
      ExecStartPost = "${pkgs.systemd}/bin/systemctl reload-or-restart caddy.service";
    };

    path = [pkgs.tailscale];
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
