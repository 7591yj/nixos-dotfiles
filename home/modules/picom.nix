{
  config,
  osConfig,
  pkgs,
  ...
}: let
  isX11 = osConfig.mySystem.displayServer == "x11";
  createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
in {
  home.packages = if isX11 then [pkgs.picom] else [];

  xdg.configFile."picom".source = createSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/picom";
}
