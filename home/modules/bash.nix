{ pkgs, ... }:

{
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

      nrfb =
        "sudo nixos-rebuild switch --flake $HOME/nixos-dotfiles#lunarlavie";
    };

    initExtra = ''
      [[ $- != *i* ]] && return

      eval "$(starship init bash)"
      eval "$(zoxide init bash)"

      fastfetch

      if [[ -f ${pkgs.blesh}/share/blesh/ble.sh ]]; then
        source ${pkgs.blesh}/share/blesh/ble.sh
      fi
    '';
  };
}
