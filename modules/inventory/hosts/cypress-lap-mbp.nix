{ ... }:
{
  repo.hosts.cypress-lap-mbp = {
    platform = "darwin";
    system = "aarch64-darwin";
    channel = "unstable";
    user = "7591yj";
    aspects = [
      "desktop-role"
      "agent-skills"
      "stylix"
      "zen-browser"
    ];
    stateVersion = 6;
    homeStateVersion = "25.11";
    darwinModules = [ ../../../hosts/cypress-lap-mbp/default.nix ];
    homeModules = [
      (
        {
          inputs,
          lib,
          pkgs,
          ...
        }:
        let
          firefoxAddons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
          extensionRoot = "share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";
          extensions = {
            "uBlock0@raymondhill.net" =
              "${firefoxAddons.ublock-origin}/${extensionRoot}/uBlock0@raymondhill.net.xpi";
            "78272b6fa58f4a1abaac99321d503a20@proton.me" =
              "${firefoxAddons.proton-pass}/${extensionRoot}/78272b6fa58f4a1abaac99321d503a20@proton.me.xpi";
            "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" =
              "${firefoxAddons.refined-github}/${extensionRoot}/{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}.xpi";
            "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" =
              "${firefoxAddons.return-youtube-dislikes}/${extensionRoot}/{762f9885-5a13-4abd-9c77-433dcd38b8fd}.xpi";
            "dfyoutube@example.com" = "${firefoxAddons.df-youtube}/${extensionRoot}/dfyoutube@example.com.xpi";
          };
        in
        {
          programs.zen-browser.policies = {
            Extensions.Install = map (path: "file://${path}") (builtins.attrValues extensions);
            ExtensionSettings = builtins.mapAttrs (_: path: {
              installation_mode = "force_installed";
              install_url = "file://${path}";
            }) extensions;
          };

          home.activation.resetZenExtensionStartupCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            profile="$HOME/Library/Application Support/Zen/Profiles/default"

            if pgrep "zen" > /dev/null 2>&1; then
              echo "zen-extensions: Zen Browser is running; close it and rebuild to refresh managed extensions."
            elif [ -d "$profile" ]; then
              run rm -f \
                "$profile/extensions.json" \
                "$profile/addonStartup.json.lz4"
              run rm -f "$profile"/extensions/*.xpi
            fi
          '';
        }
      )
    ];
  };
}
