{ config, lib, ... }:
let
  username = config.mySystem.username;
  homeDir = "/home/${username}";
  niriDmsDir = "${homeDir}/.config/niri/dms";
  dmsManagedDefaults = [
    "alttab.kdl"
    "colors.kdl"
    "cursor.kdl"
    "layout.kdl"
    "wpblur.kdl"
  ];
in
lib.mkIf (config.mySystem.desktop.compositor == "niri") {
  systemd.tmpfiles.rules = [
    "d  ${niriDmsDir} 0755 ${username} users -"
  ];

  # DMS edits these files live, so Nix only seeds defaults when they are absent.
  system.activationScripts.dmsNiriDefaults.text = ''
    ${builtins.concatStringsSep "\n" (
      map (name: ''
        if [ ! -e "${niriDmsDir}/${name}" ]; then
          install -o ${username} -g users -m 0644 \
            "${../../../../dotfiles/niri/dms + "/${name}"}" \
            "${niriDmsDir}/${name}"
        fi
      '') dmsManagedDefaults
    )}
  '';
}
