{ ... }:
{
  flake.modules.homeManager = {
    agent-skills = import ../../../modules/home-manager/agent-skills.nix;
    userdirs = import ../../../modules/home-manager/xdg-userdirs.nix;
    zen-browser = import ../../../modules/home-manager/zen-browser.nix;
  };
}
