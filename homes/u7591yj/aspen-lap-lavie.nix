{osConfig, ...}: {
  imports = [
    ../../modules/home-manager/zen-browser.nix
    ../../modules/home-manager/agent-skills.nix
    ../../modules/home-manager/lazygit.nix
    ../../modules/home-manager/xdg-userdirs.nix
  ];

  home = {
    username = osConfig.mySystem.username;
    homeDirectory = "/home/${osConfig.mySystem.username}";
    stateVersion = "25.11";
  };
}
