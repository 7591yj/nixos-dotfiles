{config, pkgs, ...}: let
  u = config.mySystem.username;
  h = "/home/${u}";
  repo = "${h}/nixos-dotfiles";
  bleshInit = "${repo}/config/blesh/init.sh";
in {
  systemd.tmpfiles.rules = [
    "L+ ${h}/.config/DankMaterialShell - - - - ${repo}/config/DankMaterialShell"
    "L+ ${h}/.config/kitty             - - - - ${repo}/config/kitty"
    "L+ ${h}/.config/niri              - - - - ${repo}/config/niri"
    "L+ ${h}/.config/zed               - - - - ${repo}/config/zed"

    # Tauon theme
    "d  ${h}/.local/share/TauonMusicBox/theme 0755 ${u} users -"
    "L+ ${h}/.local/share/TauonMusicBox/theme/tomorrow-night.ttheme - - - - ${repo}/config/tauon/tomorrow-night.ttheme"

    # blesh
    "d  /home/${u}/.config/blesh 0755 ${u} users -"
    "L+ /home/${u}/.config/blesh/init.sh - - - - ${bleshInit}"
  ];
}
