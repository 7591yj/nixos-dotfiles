{ config, ... }:
let
  u = config.mySystem.username;
  h = "/home/${u}";
  repo = "${h}/nixos-dotfiles";
in
{
  systemd.tmpfiles.rules = [
    "L+ ${h}/.config/DankMaterialShell - - - - ${repo}/dotfiles/DankMaterialShell"
    "L+ ${h}/.config/kitty             - - - - ${repo}/dotfiles/kitty"
    "L+ ${h}/.config/zed               - - - - ${repo}/dotfiles/zed"

    # Keep the static niri entrypoints repo-backed while leaving ~/.config/niri/dms
    # writable for DMS-managed live edits.
    "d  ${h}/.config/niri 0755 ${u} users -"
    "L+ ${h}/.config/niri/config.kdl     - - - - ${repo}/dotfiles/niri/config.kdl"
    "L+ ${h}/.config/niri/binds.kdl      - - - - ${repo}/dotfiles/niri/binds.kdl"
    "L+ ${h}/.config/niri/outputs.kdl    - - - - ${repo}/dotfiles/niri/outputs.kdl"
    "L+ ${h}/.config/niri/windowrules.kdl - - - - ${repo}/dotfiles/niri/windowrules.kdl"

    # Tauon theme
    "d  ${h}/.local/share/TauonMusicBox/theme 0755 ${u} users -"
    "L+ ${h}/.local/share/TauonMusicBox/theme/tomorrow-night.ttheme - - - - ${repo}/dotfiles/tauon/tomorrow-night.ttheme"

  ];
}
