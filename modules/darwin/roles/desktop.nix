{ ... }:
{
  imports = [
    ../users.nix
    ../fonts.nix
    ../fix-etc-zsh.nix
    ../packages/desktop.nix
    ../sops.nix
    ../../shared/nix.nix
    ../../shared/packages/common.nix
    ../../shared/programs/fastfetch.nix
    ../../shared/programs/neovim/default.nix
    ../../shared/programs/starship/default.nix
    ../../shared/programs/tmux/default.nix
    ../../shared/programs/yazi/default.nix
    ../../shared/programs/zsh.nix
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  home-manager.sharedModules = [
    ../desktop/mutables.nix
  ];
}
