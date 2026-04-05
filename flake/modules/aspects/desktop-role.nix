{ ... }:
{
  repo.aspects.desktop-role = {
    nixosModules = [ ../../../modules/nixos/roles/desktop.nix ];
    darwinModules = [ ../../../modules/darwin/roles/desktop.nix ];
  };
}
