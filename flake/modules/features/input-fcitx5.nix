{ ... }:
{
  repo.featureRegistry.input-fcitx5 = {
    platforms = [ "nixos" ];
    nixosModules = [ "input-fcitx5" ];
  };
}
