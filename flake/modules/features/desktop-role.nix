{ ... }:
{
  repo.featureRegistry.desktop-role = {
    nixosModules = [ "desktop-role" ];
    darwinModules = [ "desktop-role" ];
  };
}
