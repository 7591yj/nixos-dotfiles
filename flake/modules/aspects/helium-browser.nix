{ ... }:
{
  repo.aspects.helium-browser = {
    platforms = [ "nixos" ];
    nixosModules = [ ../../../modules/nixos/overlays/helium-browser.nix ];
  };
}
