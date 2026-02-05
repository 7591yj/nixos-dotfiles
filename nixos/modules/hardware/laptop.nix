{ pkgs, ... }:

{
  services.upower.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
