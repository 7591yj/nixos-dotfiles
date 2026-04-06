{ ... }:
{
  imports = [
    ../users.nix
    ../../shared/nix.nix
    ../../shared/packages/common.nix
    ../../shared/programs/bash.nix
    ../../shared/programs/fastfetch.nix
    ../../shared/programs/neovim/default.nix
    ../../shared/programs/starship/default.nix
    ../../shared/programs/tmux/default.nix
    ../../shared/programs/yazi/default.nix
  ];
}
