{ ... }:
{
  repo.aspects.server-role = {
    platforms = [ "nixos" ];
    nixosModules = [ ../../../modules/nixos/roles/server.nix ];
  };
}
