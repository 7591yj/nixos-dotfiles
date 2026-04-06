{ ... }:
{
  repo.aspects.virt-manager = {
    platforms = [ "nixos" ];
    nixosModules = [ ../nixos/virt-manager.nix ];
  };
}
