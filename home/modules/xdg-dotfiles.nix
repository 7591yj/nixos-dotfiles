{config, ...}: let
  dotfiles = ../../config;
  createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;

  mutableConfigs = {
    DankMaterialShell = "DankMaterialShell";
    kitty = "kitty";
    niri = "niri";
    zed = "zed";
  };

  immutableConfigs = {
    lazygit = "lazygit";
  };
in {
  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";
    };
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
