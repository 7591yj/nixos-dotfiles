{ ... }:
{
  repo.featureRegistry.server-role = {
    platforms = [ "nixos" ];
    nixosModules = [ "server-role" ];
  };
}
