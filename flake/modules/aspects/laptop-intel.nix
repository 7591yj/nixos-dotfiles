{ ... }:
{
  repo.aspects.laptop-intel = {
    platforms = [ "nixos" ];
    nixosModules = [
      {
        imports = [
          ../../../modules/nixos/hardware/intel.nix
          ../../../modules/nixos/hardware/laptop.nix
        ];
      }
    ];
  };
}
