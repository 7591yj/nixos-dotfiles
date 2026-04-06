{ ... }:
{
  repo.aspects.desktop-role = {
    nixosModules = [ ../nixos/roles/desktop.nix ];
    darwinModules = [ ../darwin/roles/desktop.nix ];
  };
}
