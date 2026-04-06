{ ... }:
{
  repo.aspects.container-services = {
    platforms = [ "nixos" ];
    nixosModules = [
      {
        imports = [
          ../nixos/sops.nix
          ../nixos/services/containers
          ../nixos/services/containers/jellyfin.nix
          ../nixos/services/caddy
        ];
      }
    ];
  };
}
