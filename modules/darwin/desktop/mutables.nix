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
    "ghostty/config".source = link "${repo}/dotfiles/ghostty/config.ghostty";
    "lazygit".source = link "${repo}/dotfiles/lazygit";
    "zed".source = link "${repo}/dotfiles/zed";
  };

  # pi
  home.file = {
    ".pi/agent/models.json" = {
      source = link "${repo}/dotfiles/pi/agent/models.json";
      force = true;
    };
    ".pi/agent/settings.json" = {
      source = link "${repo}/dotfiles/pi/agent/settings.json";
      force = true;
    };
    ".pi/agent/extensions" = {
      source = link "${repo}/dotfiles/pi/agent/extensions";
      force = true;
    };
    ".pi/agent/themes" = {
      source = link "${repo}/dotfiles/pi/agent/themes";
      force = true;
    };
  };

  xdg.dataFile."TauonMusicBox/theme/tomorrow-night.ttheme".source =
    link "${repo}/dotfiles/tauon/tomorrow-night.ttheme";
}
