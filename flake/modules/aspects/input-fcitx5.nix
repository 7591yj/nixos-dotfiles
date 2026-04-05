{ ... }:
{
  repo.aspects.input-fcitx5 = {
    platforms = [ "nixos" ];
    nixosModules = [ ../../../modules/nixos/locale/input-fcitx5.nix ];
  };
}
