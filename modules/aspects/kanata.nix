{ ... }:
{
  repo.aspects.kanata = {
    platforms = [
      "nixos"
      "darwin"
    ];
    darwinModules = [ ../darwin/kanata.nix ];
    nixosModules = [
      {
        boot.kernelModules = [ "uinput" ];
        hardware.uinput.enable = true;

        services.udev.extraRules = ''
          KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
        '';

        users.groups.uinput = { };

        services.kanata = {
          enable = true;
          keyboards.internal = {
            devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
            extraDefCfg = "process-unmapped-keys yes";
            config = ''
              (defsrc
                caps lctl
              )
              (deflayer base
                lctl caps
              )
            '';
          };
        };

        systemd.services.kanata-internal = {
          unitConfig.ConditionPathExists = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
          serviceConfig.SupplementaryGroups = [
            "input"
            "uinput"
          ];
        };
      }
    ];
  };
}
