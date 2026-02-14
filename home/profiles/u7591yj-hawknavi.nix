{pkgs, ...}: {
  imports = [
    ../modules/packages/common.nix
    ../modules/git.nix
    ../modules/bash.nix
    ../modules/starship.nix
    ../modules/xdg-dotfiles.nix
    ../modules/nvf.nix
  ];

  home = {
    username = "u7591yj";
    homeDirectory = "/home/u7591yj";
    stateVersion = "25.11";
  };
}
