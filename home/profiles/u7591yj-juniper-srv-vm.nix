{osConfig, ...}: {
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
    username = osConfig.mySystem.username;
    homeDirectory = "/home/${osConfig.mySystem.username}";
    stateVersion = "25.11";
  };
}
