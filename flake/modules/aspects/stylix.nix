{ inputs, ... }:
{
  repo.aspects.stylix = {
    platforms = [ "nixos" ];
    nixosModules = [
      {
        imports = [
          inputs.stylix.nixosModules.stylix
          ../../../modules/nixos/desktop/stylix.nix
        ];
      }
    ];
  };
}
