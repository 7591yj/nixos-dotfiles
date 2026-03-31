{
  pkgs,
  config,
  ...
}: let
  u = config.mySystem.username;
in {
  environment.systemPackages = [pkgs.blesh];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    shellAliases = {
      ls = "eza --color=auto";
      ll = "eza -al --color=auto";
      grep = "grep --color=auto";
      lg = "lazygit";
      gcl = "git clone";
      gs = "git switch";
      gA = "git add .";
      gp = "git pull origin main";
      gP = "git push origin main";
    };

    interactiveShellInit = ''
      source -- "${pkgs.blesh}/share/blesh/ble.sh" --attach=none

      set -o vi

      nixx() {
        nixos-rebuild --sudo switch -L --flake "$HOME/nixos-dotfiles#$(hostname)"
      }

      eval "$(starship init bash)"
      eval "$(zoxide init bash)"

      fastfetch

      [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';
  };
}
