{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      # toolchain
      diffutils
      pv
      duf

      # editor
      neovim

      # network
      tailscale
      rsync
      wget

      # archives
      unzipNLS
      unrar
      p7zip
      file

      # usb
      usbutils

      # graphics
      ffmpeg-full

      # security
      libsecret
    ]
    ++ lib.optionals (config.mySystem.displayServer == "wayland") [
      xwayland-satellite
    ];

  programs.nano.enable = false;
}
