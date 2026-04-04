{ inputs, ... }:
{
  nixpkgs.overlays = [ inputs.helium-browser.overlay ];
}
