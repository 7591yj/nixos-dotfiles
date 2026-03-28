{ ... }: {
  imports = [
    ../../shared/nix.nix
    ../../shared/packages/common.nix
    ../../shared/programs/bash.nix
    ../../shared/programs/git.nix
    ../../shared/programs/nvf.nix
    ../../shared/programs/starship/default.nix
    ../../shared/programs/tmux/default.nix
    ../../shared/programs/yazi/default.nix
  ];
}
