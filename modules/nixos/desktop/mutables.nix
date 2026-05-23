{ config, ... }:
let
  u = config.mySystem.username;
  h = "/home/${u}";
  repo = "${h}/nixos-dotfiles";
in
{
  systemd.tmpfiles.rules = [
    "L+ ${h}/.config/DankMaterialShell - - - - ${repo}/dotfiles/DankMaterialShell"
    "d  ${h}/.config/ghostty 0755 ${u} users -"
    "L+ ${h}/.config/ghostty/config.ghostty - - - - ${repo}/dotfiles/ghostty/config.ghostty"
    "L+ ${h}/.config/zed               - - - - ${repo}/dotfiles/zed"

    # Pi coding-agent custom providers
    "d  ${h}/.pi/agent 0755 ${u} users -"
    "L+ ${h}/.pi/agent/models.json - - - - ${repo}/dotfiles/pi/agent/models.json"
    "L+ ${h}/.pi/agent/settings.json - - - - ${repo}/dotfiles/pi/agent/settings.json"
    "L+ ${h}/.pi/agent/extensions - - - - ${repo}/dotfiles/pi/agent/extensions"
    "L+ ${h}/.pi/agent/themes - - - - ${repo}/dotfiles/pi/agent/themes"

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
