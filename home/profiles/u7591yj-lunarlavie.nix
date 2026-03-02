{osConfig, ...}: {
  imports = [
    ../modules/packages/common.nix
    ../modules/packages/desktop.nix
    ../modules/zen-browser.nix
    ../modules/helium.nix
    ../modules/git.nix
    ../modules/bash.nix
    ../modules/starship.nix
    ../modules/tmux.nix
    ../modules/nvf.nix
    ../modules/yazi.nix
    ../modules/fastfetch.nix
    ../modules/xdg-dotfiles.nix
    ../modules/pwa.nix
  ];

  home = {
    username = osConfig.mySystem.username;
    homeDirectory = "/home/${osConfig.mySystem.username}";
    stateVersion = "25.11";
  };
}
