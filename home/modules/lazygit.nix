{...}: let
  dotfiles = ../../config;
in {
  xdg.configFile."lazygit".source = dotfiles + "/lazygit";
}
