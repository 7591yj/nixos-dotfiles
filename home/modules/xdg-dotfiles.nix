{config, ...}: let
  dotfiles = ../../config;
  createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;

  mutableConfigs = {
    DankMaterialShell = "DankMaterialShell";
    niri = "niri";
    zed = "zed";
  };

  immutableConfigs = {
    alacritty = "alacritty";
    lazygit = "lazygit";
  };
in {
  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  xdg.configFile =
    (builtins.mapAttrs (_name: subpath: {
        source = createSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/${subpath}";
      })
      mutableConfigs)
    // (builtins.mapAttrs (_name: subpath: {
        source = dotfiles + "/${subpath}";
      })
      immutableConfigs);
}
