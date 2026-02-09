{ ... }:

{
  imports = [
    ../boot.nix
    ../nix.nix
    ../users.nix

    ../networking/server.nix
    ../locale/base.nix

    ../services/openssh.nix
    ../services/smartd.nix

    ../packages/server.nix

    ../tailscale.nix
  ];
}
