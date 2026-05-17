{ inputs, ... }:
{
  repo.aspects.stylix = {
    platforms = [
      "nixos"
      "darwin"
    ];
    nixosModules = [
      {
        imports = [
          inputs.stylix.nixosModules.stylix
          ../nixos/desktop/stylix.nix
        ];
      }
    ];
    darwinModules = [
      {
        imports = [
          inputs.stylix.darwinModules.stylix
          ../darwin/desktop/stylix.nix
        ];
      }
    ];
  };
}
