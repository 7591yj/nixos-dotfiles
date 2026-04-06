{ ... }:
{
  repo.aspects.server-role = {
    platforms = [ "nixos" ];
    nixosModules = [ ../nixos/roles/server.nix ];
  };
}
