{ inputs, ... }:
{
  repo.aspects.hex = {
    platforms = [
      "nixos"
      "darwin"
    ];
    includes = [ "kanata" ];
    darwinModules = [
      {
        homebrew.taps = [ "anomalyco/tap" ];
        homebrew.casks = [ "anomalyco/tap/hex" ];
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
          username = config.mySystem.username;
          home = config.home-manager.users.${username};
          hex = lib.getExe home.programs.hex.package;
        in
        {
          home-manager.users.${username} = {
            imports = [ inputs.hex.homeManagerModules.hex ];
            programs.hex = {
              enable = true;
              autostart = true;
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
                  hex-start (cmd ${hex} dictation start)
                  hex-stop (cmd ${hex} dictation stop)
                )
                (defalias
                  hex-push-to-talk (multi
                    (on-press tap-vkey hex-start)
                    (on-release tap-vkey hex-stop)
                  )
                  space (switch
                    ((and (input real caps) (or (input real lsft) (input real rsft)))) @hex-push-to-talk break
                    () spc break
                  )
                )
                (deflayer base
                  lctl caps @space
                )
              '';
            };
          };

          # Hex's control socket is accessible only to the desktop user.
          systemd.services.kanata-internal = {
            environment.HEX_APPLICATION_SUPPORT_DIR = "${home.xdg.dataHome}/hex";
            serviceConfig = {
              DynamicUser = lib.mkForce false;
              PrivateUsers = lib.mkForce false;
              ProtectHome = lib.mkForce "read-only";
              User = username;
            };
          };
        }
      )
    ];
  };
}
