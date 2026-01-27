{ pkgs, ... }:

{
  imports = [
    ../modules/packages.nix
    ../modules/git.nix
    ../modules/bash.nix
    ../modules/xdg-dotfiles.nix
    ../modules/polkit-agent.nix
    ../modules/neovim.nix
  ];

  home = {
    username = "u7591yj";
    homeDirectory = "/home/u7591yj";
    stateVersion = "25.11";
    packages = [ pkgs.helium ];
  };
}

