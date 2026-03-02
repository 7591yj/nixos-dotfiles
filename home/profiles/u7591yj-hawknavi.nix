{pkgs, ...}: {
  imports = [
    ../modules/packages/common.nix
    ../modules/git.nix
    ../modules/bash.nix
    ../modules/starship.nix
    ../modules/tmux.nix
    ../modules/nvf.nix
    ../modules/fastfetch.nix
    ../modules/xdg-dotfiles.nix
  ];

  home = {
    username = "u7591yj";
    homeDirectory = "/home/u7591yj";
    stateVersion = "25.11";
  };
}
