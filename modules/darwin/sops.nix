{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.sops-nix.darwinModules.sops ];

  environment.systemPackages = with pkgs; [
    sops
  ];

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    gnupg.sshKeyPaths = [ ];
  };
}
