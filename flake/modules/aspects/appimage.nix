{ ... }:
{
  repo.aspects.appimage = {
    platforms = [ "nixos" ];
    nixosModules = [ ../../../modules/nixos/appimage.nix ];
  };
}
