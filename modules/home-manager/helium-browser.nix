{
  heliumBrowserConfig,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  preferencesJson = builtins.toJSON heliumBrowserConfig.preferences;
  preferencesDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "$HOME/Library/Application Support/net.imput.helium/Default"
    else
      "$HOME/.config/net.imput.helium/Default";
in
{
  home.packages = [ inputs."helium-browser".packages.${system}.helium ];

  home.activation.heliumPreferences = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    prefs_dir=${lib.escapeShellArg preferencesDirectory}
    prefs_file="$prefs_dir/Preferences"
    nix_prefs=${lib.escapeShellArg preferencesJson}

    run mkdir -p "$prefs_dir"

    if [ -f "$prefs_file" ]; then
      ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$prefs_file" - <<< "$nix_prefs" > "$prefs_file.tmp"
      run mv "$prefs_file.tmp" "$prefs_file"
    else
      printf '%s\n' "$nix_prefs" > "$prefs_file"
    fi
  '';
}
