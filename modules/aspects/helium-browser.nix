{ inputs, lib, ... }:
let
  inherit (import ../shared/helium-browser-config.nix) policies preferences;
in
{
  repo.aspects.helium-browser = {
    platforms = [
      "nixos"
      "darwin"
    ];
    homeModules = [
      {
        _module.args.heliumBrowserConfig = {
          inherit policies preferences;
        };
      }
      ../home-manager/helium-browser.nix
    ];
    nixosModules = [
      {
        environment.etc."chromium/policies/managed/helium.json".text = builtins.toJSON policies;
      }
    ];
    darwinModules = [
      (
        { pkgs, ... }:
        let
          policyPlist = pkgs.writeText "helium-policies.plist" (
            lib.generators.toPlist { escape = true; } policies
          );
        in
        {
          system.activationScripts.postActivation.text = ''
            echo "installing managed Helium policies..." >&2
            mkdir -p "/Library/Managed Preferences"
            install -m 0644 ${policyPlist} "/Library/Managed Preferences/net.imput.helium.plist"
          '';
        }
      )
    ];
  };
}
