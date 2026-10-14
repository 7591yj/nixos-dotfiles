{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.neovim.override {
      viAlias = true;
      vimAlias = true;
      withPython3 = false;
      withNodeJs = false;
      withRuby = false;
      configure.customLuaRC = builtins.readFile ./config/init.lua;
    })
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
