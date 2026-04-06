{ ... }:
{
  repo.aspects.laptop-intel = {
    platforms = [ "nixos" ];
    nixosModules = [
      {
        imports = [
          ../nixos/hardware/intel.nix
          ../nixos/hardware/laptop.nix
        ];
      }
    ];
  };
}
