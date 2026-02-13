{pkgs, ...}: {
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

      vi = "nvim";
      vim = "nvim";
    };

    initExtra = ''
      [[ $- != *i* ]] && return

      nixx() {
        case "$1" in
          rebuild)
            nixos-rebuild --sudo switch --flake "$HOME/nixos-dotfiles#$(hostname)"
            ;;
          garbage-save)
            nix-env --delete-generations +3
            ;;
          garbage)
            nix-collect-garbage -d
            ;;
          optimise)
            nix store optimise
            ;;
          *)
            echo "Usage: nixx {rebuild|garbage|garbage-save|optimise}" >&2
            return 1
            ;;
        esac
      }

      export UV_PYTHON_PREFERENCE=system

      eval "$(starship init bash)"
      eval "$(zoxide init bash)"

      fastfetch

      if [[ -f ${pkgs.blesh}/share/blesh/ble.sh ]]; then
        source ${pkgs.blesh}/share/blesh/ble.sh
      fi
    '';
  };
}
