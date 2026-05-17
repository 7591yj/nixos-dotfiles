{ ... }:
{
  services.karabiner-elements.enable = true;

  home-manager.sharedModules = [ ../home-manager/karabiner.nix ];
}
