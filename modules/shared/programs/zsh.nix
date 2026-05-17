{
  lib,
  options,
  pkgs,
  ...
}:
let
  shellAliases = import ./shell-aliases.nix;
  rebuildCommand =
    if pkgs.stdenv.isDarwin then
      "sudo darwin-rebuild switch --flake \"$HOME/nixos-dotfiles#$(scutil --get LocalHostName 2>/dev/null || hostname -s)\""
    else
      "nixos-rebuild --sudo switch -L --flake \"$HOME/nixos-dotfiles#$(hostname)\"";
in
lib.mkMerge (
  [
    {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      environment.shellAliases = shellAliases;

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        promptInit = "";

        interactiveShellInit = ''
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

          eval "$(starship init zsh)"
          eval "$(zoxide init zsh)"

          if [[ -z ''${FASTFETCH_SHOWN-} ]]; then
            export FASTFETCH_SHOWN=1
            fastfetch
          fi
        '';
      };
    }
  ]
  ++ lib.optionals (options.programs.zsh ? enableAutosuggestions) [
    {
      programs.zsh.enableAutosuggestions = true;
    }
  ]
  ++ lib.optionals (options.programs.zsh ? enableSyntaxHighlighting) [
    {
      programs.zsh.enableSyntaxHighlighting = true;
    }
  ]
  ++ lib.optionals (options.programs.zsh ? autosuggestions) [
    {
      programs.zsh.autosuggestions.enable = true;
    }
  ]
  ++ lib.optionals (options.programs.zsh ? syntaxHighlighting) [
    {
      programs.zsh.syntaxHighlighting.enable = true;
    }
  ]
)
