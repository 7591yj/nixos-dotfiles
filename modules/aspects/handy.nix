{ ... }:
{
  repo.aspects.handy = {
    platforms = [
      "nixos"
      "darwin"
    ];
    includes = [ "kanata" ];
    darwinModules = [
      {
        homebrew.casks = [ "handy" ];
      }
    ];
    nixosModules = [
      (
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          handy = pkgs.callPackage ../../pkgs/handy.nix { };
          username = config.mySystem.username;
        in
        {
          environment.systemPackages = [ handy ];

          systemd.user.services.handy = {
            description = "Handy speech-to-text";
            wantedBy = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
              ExecStart = "${lib.getExe handy} --start-hidden";
              Restart = "on-failure";
            };
          };

          services.kanata = {
            package = pkgs.kanata-with-cmd;
            keyboards.internal = {
              extraDefCfg = lib.mkForce ''
                process-unmapped-keys yes
                danger-enable-cmd yes
              '';
              config = lib.mkForce ''
                (defsrc
                  caps lctl spc
                )
                (defvirtualkeys
                  handy-toggle (cmd ${pkgs.procps}/bin/pkill -USR2 -n handy)
                )
                (defalias
                  handy-push-to-talk (multi
                    (on-press tap-vkey handy-toggle)
                    (on-release tap-vkey handy-toggle)
                  )
                  space (switch
                    ((and (input real caps) (or (input real lsft) (input real rsft)))) @handy-push-to-talk break
                    () spc break
                  )
                )
                (deflayer base
                  lctl caps @space
                )
              '';
            };
          };

          # Kanata must run as the desktop user so its command can signal Handy.
          systemd.services.kanata-internal.serviceConfig = {
            DynamicUser = lib.mkForce false;
            PrivateUsers = lib.mkForce false;
            ProtectProc = lib.mkForce "default";
            ProcSubset = lib.mkForce "all";
            User = username;
          };
        }
      )
    ];
  };
}
