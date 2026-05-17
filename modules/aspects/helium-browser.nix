{ inputs, ... }:
{
  repo.aspects.helium-browser = {
    platforms = [
      "nixos"
      "darwin"
    ];
    homeModules = [ ../home-manager/helium-browser.nix ];
    nixosModules = [ inputs."helium-browser".nixosModules.helium ];
    darwinModules = [
      {
        nixpkgs.overlays = [ inputs.helium-browser.overlay ];
      }
    ];
  };
}
