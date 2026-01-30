{ pkgs, ... }:

{
  security.polkit.enable = true;

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "default.target" ];
    
    serviceConfig = {
      ExecStart = ''
        /usr/bin/env XDG_CURRENT_DESKTOP=GNOME \
            GDMSESSION=gnome \
            ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      '';
      Restart = "on-failure";
    };
  };
}
