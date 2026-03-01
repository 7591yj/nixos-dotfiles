{...}: {
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
    ../modules/xdg-dotfiles.nix
    ../modules/pwa.nix
  ];

  home = {
    username = "u7591yj";
    homeDirectory = "/home/u7591yj";
    stateVersion = "25.11";
  };
}
