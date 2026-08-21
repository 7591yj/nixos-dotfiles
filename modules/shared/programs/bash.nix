{
  lib,
  pkgs,
  config,
  ...
}:
let
  enableBlesh = true;
  bleshInit = builtins.readFile ./blesh/init.sh;
  shellAliases = import ./shell-aliases.nix;
  rebuildCommand = if pkgs.stdenv.hostPlatform.isDarwin then "nh darwin switch" else "nh os switch";
  buildCommand = if pkgs.stdenv.hostPlatform.isDarwin then "nh darwin build" else "nh os build";
  dryRunCommand =
    if pkgs.stdenv.hostPlatform.isDarwin then "nh darwin switch --dry" else "nh os switch --dry";
in
{
  nixpkgs.overlays = [
    (final: prev: {
      blesh = prev.blesh.overrideAttrs (oldAttrs: {
        version = "0.4.0-devel3-pinned";
        src = final.fetchFromGitHub {
          owner = "akinomyoga";
          repo = "ble.sh";
          rev = "1a5c451c8baa71439a6be4ea0f92750de35a7620";
          fetchSubmodules = true;
          hash = "sha256-KBBNrEY3CRBCFpLESjfgXPyHCyWDvjH6VIdmnWTNyac=";
        };
        postPatch = (oldAttrs.postPatch or "") + ''
          substituteInPlace GNUmakefile \
            --replace-fail 'ble.pp GNUmakefile | .git $(OUTDIR)' 'ble.pp GNUmakefile | $(OUTDIR)'
          substituteInPlace ble.pp \
            --replace-fail '#%[commit_hash = system("git show -s --format=%h")]' '#%[commit_hash = "1a5c451"]' \
            --replace-fail '#%$ echo "_ble_base_branch=$(git rev-parse --abbrev-ref HEAD)"' '#%$ echo "_ble_base_branch=master"'
        '';
      });
    })
  ];

  environment.systemPackages = lib.optionals (pkgs.stdenv.hostPlatform.isLinux && enableBlesh) [
    pkgs.blesh
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    inherit shellAliases;

    promptInit = "";

    interactiveShellInit = ''
      ${lib.optionalString (pkgs.stdenv.hostPlatform.isLinux && enableBlesh) ''
        _blesh_cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/blesh"
        _blesh_nix_marker="$_blesh_cache_dir/nix-store-path"
        if [[ ! -r $_blesh_nix_marker ]] || [[ $(< "$_blesh_nix_marker") != "${pkgs.blesh}" ]]; then
          bash "${pkgs.blesh}/share/blesh/ble.sh" --clear-cache >/dev/null 2>&1 || true
          mkdir -p -- "$_blesh_cache_dir"
          printf '%s\n' "${pkgs.blesh}" >| "$_blesh_nix_marker"
        fi
        unset _blesh_cache_dir _blesh_nix_marker

        source "${pkgs.blesh}/share/blesh/ble.sh" --attach=none
        ${bleshInit}
      ''}

      set -o vi

      export NH_FLAKE="$HOME/nixos-dotfiles"

      nr() {
        ${rebuildCommand}
      }

      nb() {
        ${buildCommand}
      }

      nrd() {
        ${dryRunCommand}
      }

      eval "$(starship init bash)"
      eval "$(zoxide init bash)"

      fastfetch

      ${lib.optionalString (pkgs.stdenv.hostPlatform.isLinux && enableBlesh) ''
        [[ ! ''${BLE_VERSION-} ]] || ble-attach
      ''}

    '';
  };
}
