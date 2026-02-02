{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    DankMaterialShell = "DankMaterialShell";
    fastfetch = "fastfetch";
    wezterm = "wezterm";
    lazygit = "lazygit";
    niri = "niri";
    tmux = "tmux";
    zed = "zed";
  };
in
{
  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  xdg.configFile = builtins.mapAttrs (_name: subpath: {
    source = createSymlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs
  // {
      "starship.toml".source =
        createSymlink "${dotfiles}/starship.toml";
  };
}
