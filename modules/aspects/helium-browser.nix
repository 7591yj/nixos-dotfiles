{ inputs, ... }:
{
  repo.aspects.helium-browser = {
    homeModules = [ ../home-manager/helium-browser.nix ];
    nixosModules = [ inputs."helium-browser".nixosModules.helium ];
  };
}
