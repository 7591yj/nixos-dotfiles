{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-dotfiles/config/nvim";
    recursive = true;
  };
}
