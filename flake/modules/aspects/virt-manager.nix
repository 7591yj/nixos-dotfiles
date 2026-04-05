{ ... }:
{
  repo.aspects.virt-manager = {
    platforms = [ "nixos" ];
    nixosModules = [ ../../../modules/nixos/virt-manager.nix ];
  };
}
