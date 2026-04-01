{ ... }:
let
  dotfiles = ../../dotfiles;
in
{
  xdg.configFile."lazygit".source = dotfiles + "/lazygit";
}
