{ lib, pkgs, ... }:
let
  shellAliases = import ../shared/programs/shell-aliases.nix;
  rebuildCommand =
    "sudo darwin-rebuild switch --flake \"$HOME/nixos-dotfiles#$(scutil --get LocalHostName 2>/dev/null || hostname -s)\"";
in
{
  # Robustness pattern for macOS: keep user-facing shell customisation in the
  # user's zshrc, not only in /etc/zshrc. macOS updates may replace /etc/zshrc
  # and /etc/zprofile, but they do not touch ~/.zshrc.
  home-manager.sharedModules = [
    ({ lib, ... }: {
      programs.zsh = {
        enable = true;
        shellAliases = shellAliases;
        initContent = lib.mkAfter ''
          autoload -Uz colors
          colors

          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          zstyle ':completion:*' menu select
          zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
          zstyle ':completion:*' special-dirs true

          bindkey -v

          nixx() {
            ${rebuildCommand}
          }

          if command -v starship >/dev/null 2>&1; then
            eval "$(starship init zsh)"
          fi

          if command -v zoxide >/dev/null 2>&1; then
            eval "$(zoxide init zsh)"
          fi

          if [[ -z ''${FASTFETCH_SHOWN-} ]] && command -v fastfetch >/dev/null 2>&1; then
            export FASTFETCH_SHOWN=1
            fastfetch
          fi
        '';
      };
    })
  ];

  # Also repair nix-darwin's /etc links after activation. This is secondary:
  # ~/.zshrc above keeps shells usable even if macOS replaces /etc again.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo "ensuring nix-darwin zsh startup files are linked..." >&2

    for file in zshrc zprofile; do
      target="/etc/$file"
      source="/etc/static/$file"

      if [ ! -e "$source" ]; then
        echo "warning: $source does not exist; skipping $target" >&2
        continue
      fi

      if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        continue
      fi

      if [ -e "$target" ] || [ -L "$target" ]; then
        backup="$target.before-nix-darwin.$(/bin/date +%Y%m%d%H%M%S)"
        echo "moving $target to $backup" >&2
        mv "$target" "$backup"
      fi

      echo "linking $target -> $source" >&2
      ln -s "$source" "$target"
    done
  '';
}
