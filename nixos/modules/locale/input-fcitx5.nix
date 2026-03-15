{
  config,
  lib,
  pkgs,
  ...
}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-mozc fcitx5-hangul];
    fcitx5.waylandFrontend = config.mySystem.displayServer == "wayland";
  };

  environment.sessionVariables = lib.mkIf (config.mySystem.displayServer == "wayland") {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
  };
}
