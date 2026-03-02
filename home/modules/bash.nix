{pkgs, ...}: {
  home.packages = [pkgs.blesh];

  programs.bash = {
    enable = true;

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

    initExtra = ''
      [[ $- != *i* ]] && return

      source -- "${pkgs.blesh}/share/blesh/ble.sh" --attach=none

      nixx() {
        nixos-rebuild --sudo switch --flake "$HOME/nixos-dotfiles#$(hostname)"
      }

      export UV_PYTHON_PREFERENCE=system

      eval "$(starship init bash)"
      eval "$(zoxide init bash)"

      fastfetch

      [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';
  };

}
