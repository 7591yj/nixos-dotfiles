{ ... }:
{
  homebrew.casks = [ "karabiner-elements" ];

  home-manager.sharedModules = [ ../home-manager/karabiner.nix ];
}
