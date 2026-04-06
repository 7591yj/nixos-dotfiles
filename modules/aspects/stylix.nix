{ inputs, ... }:
{
  repo.aspects.stylix = {
    platforms = [ "nixos" ];
    nixosModules = [
      {
        imports = [
          inputs.stylix.nixosModules.stylix
          ../nixos/desktop/stylix.nix
        ];
      }
    ];
  };
}
