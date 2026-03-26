{osConfig, ...}: {
  imports = [
    ../modules/zen-browser.nix
    ../modules/nvf.nix
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
