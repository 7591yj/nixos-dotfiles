{
  pkgs,
  inputs,
  config,
  ...
}:
let
  user = config.mySystem.username;
  home = "/home/${user}";
  piSecrets = ../../secrets/pi.yaml;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.systemPackages = with pkgs; [
    sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets.firecrawl_api_key = {
      sopsFile = piSecrets;
      owner = user;
    };

    templates."pi-firecrawl.env" = {
      content = ''
        FIRECRAWL_API_KEY=${config.sops.placeholder.firecrawl_api_key}
      '';
      path = "${home}/.pi/agent/.env";
      owner = user;
      mode = "0400";
    };
  };
}
