{ inputs, ... }:
{
  repo.aspects.helium-browser = {
    platforms = [ "nixos" ];
    nixosModules = [
      {
        nixpkgs.overlays = [ inputs.helium-browser.overlay ];
      }
    ];
  };
}
