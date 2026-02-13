{ ... }:

{
  imports = [
    ../modules/packages/common.nix
    ../modules/packages/desktop.nix
    ../modules/zen-browser.nix
    ../modules/helium.nix
    ../modules/git.nix
    ../modules/bash.nix
    ../modules/nvf.nix
    ../modules/yazi.nix
    ../modules/xdg-dotfiles.nix
  ];

  home = {
    username = "u7591yj";
    homeDirectory = "/home/u7591yj";
    stateVersion = "25.11";
  };
}
