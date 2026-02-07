{ pkgs, ... }:

{
  imports = [
    ../modules/packages.nix
    ../modules/git.nix
    ../modules/bash.nix
    ../modules/xdg-dotfiles.nix
    ../modules/neovim.nix
  ];

  home = {
    username = "u7591yj";
    homeDirectory = "/home/u7591yj";
    stateVersion = "25.11";
    packages = [ pkgs.helium ];
  };

  gtk = {
    theme.package = pkgs.whitesur-gtk-theme;
    theme.name = "WhiteSur-dark";
    iconTheme.package = pkgs.whitesur-icon-theme;
    iconTheme.name = "WhiteSur-dark";
  };
  
  home.pointerCursor = {
    package = pkgs.whitesur-cursors;
    name = "WhiteSur-cursors";
    size = 24;
  };
}

