{ ... }:
{
  repo.aspects.kanata = {
    platforms = [ "nixos" ];
    nixosModules = [ ../../../modules/nixos/locale/kanata.nix ];
  };
}
