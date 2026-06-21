{
  lib,
  pkgs,
  config,
  ...
}:
let
  bleshInit = builtins.readFile ./blesh/init.sh;
  shellAliases = import ./shell-aliases.nix;
  rebuildCommand = if pkgs.stdenv.isDarwin then "nh darwin switch" else "nh os switch";
  buildCommand = if pkgs.stdenv.isDarwin then "nh darwin build" else "nh os build";
  dryRunCommand = if pkgs.stdenv.isDarwin then "nh darwin switch --dry" else "nh os switch --dry";
in
{
  environment.systemPackages = lib.optionals pkgs.stdenv.isLinux [ pkgs.blesh ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    inherit shellAliases;

    interactiveShellInit = ''
      ${lib.optionalString pkgs.stdenv.isLinux ''
        source -- "${pkgs.blesh}/share/blesh/ble.sh" --attach=none
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

      ${lib.optionalString pkgs.stdenv.isLinux ''
        [[ ! ''${BLE_VERSION-} ]] || ble-attach
      ''}
    '';
  };
}
