{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # neovim
    neovim

    # telescope
    ripgrep
    fd
    fzf

    # lsp
    lua-language-server
    nil
    nixpkgs-fmt

    # lazy
    nodejs
  ];

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixos-dotfiles/config/nvim";
}
