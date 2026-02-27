{pkgs, ...}: {
  virtualisation.waydroid.enable = true;
  environment.systemPackages = [pkgs.waydroid-helper];
  services.waydroid-mount.wantedBy = ["multi-user.target"];
}
