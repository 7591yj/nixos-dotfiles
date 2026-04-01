{config, ...}: let
  u = config.mySystem.username;
  h = "/home/${u}";
  repo = "${h}/nixos-dotfiles";
in {
  systemd.tmpfiles.rules = [
    "L+ ${h}/.config/DankMaterialShell - - - - ${repo}/dotfiles/DankMaterialShell"
    "L+ ${h}/.config/kitty             - - - - ${repo}/dotfiles/kitty"
    "L+ ${h}/.config/niri              - - - - ${repo}/dotfiles/niri"
    "L+ ${h}/.config/zed               - - - - ${repo}/dotfiles/zed"

    # Tauon theme
    "d  ${h}/.local/share/TauonMusicBox/theme 0755 ${u} users -"
    "L+ ${h}/.local/share/TauonMusicBox/theme/tomorrow-night.ttheme - - - - ${repo}/dotfiles/tauon/tomorrow-night.ttheme"

  ];
}
