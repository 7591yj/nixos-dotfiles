{osConfig, ...}: {
  imports = [
    ../modules/zen-browser.nix
    ../modules/git.nix
    ../modules/bash.nix
    ../modules/starship.nix
    ../modules/tmux.nix
    ../modules/nvf.nix
    ../modules/yazi.nix
    ../modules/agent-skills.nix
    ../modules/lazygit.nix
    ../modules/xdg-userdirs.nix
  ];

  home = {
    username = osConfig.mySystem.username;
    homeDirectory = "/home/${osConfig.mySystem.username}";
    stateVersion = "25.11";
  };
}
