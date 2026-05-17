{
  lib,
  pkgs,
  config,
  ...
}:
let
  bleshInit = builtins.readFile ./blesh/init.sh;
  shellAliases = import ./shell-aliases.nix;
  rebuildCommand =
    if pkgs.stdenv.isDarwin then
      "darwin-rebuild switch --flake \"$HOME/nixos-dotfiles#$(scutil --get LocalHostName 2>/dev/null || hostname -s)\""
    else
      "nixos-rebuild --sudo switch -L --flake \"$HOME/nixos-dotfiles#$(hostname)\"";
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

      nixx() {
        ${rebuildCommand}
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
