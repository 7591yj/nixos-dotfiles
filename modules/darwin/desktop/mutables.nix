{
  config,
  ...
}:
let
  repo = "${config.home.homeDirectory}/nixos-dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  xdg.enable = true;

  xdg.configFile = {
    "ghostty/config".source = link "${repo}/dotfiles/ghostty/config.ghostty";
    "ghostty/platform.ghostty".source = link "${repo}/dotfiles/ghostty/platform.darwin.ghostty";
    "lazygit".source = link "${repo}/dotfiles/lazygit";
    "zed".source = link "${repo}/dotfiles/zed";
  };

  xdg.dataFile."TauonMusicBox/theme/tomorrow-night.ttheme".source =
    link "${repo}/dotfiles/tauon/tomorrow-night.ttheme";
}
