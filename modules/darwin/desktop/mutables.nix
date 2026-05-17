{
  config,
  lib,
  pkgs,
  ...
}:
let
  repo = "${config.home.homeDirectory}/nixos-dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.packages = [
    pkgs.plemoljp-nf
  ];

  home.activation.installPlemolFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.rsync}/bin/rsync $VERBOSE_ARG -acL --chmod=u+w \
      ${pkgs.plemoljp-nf}/share/fonts/truetype/plemoljp-nf-35console/*.ttf \
      "$HOME/Library/Fonts/"
  '';

  xdg.enable = true;

  xdg.configFile = {
    "kitty".source = link "${repo}/dotfiles/kitty";
    "lazygit".source = link "${repo}/dotfiles/lazygit";
    "zed".source = link "${repo}/dotfiles/zed";
  };

  xdg.dataFile."TauonMusicBox/theme/tomorrow-night.ttheme".source =
    link "${repo}/dotfiles/tauon/tomorrow-night.ttheme";
}
