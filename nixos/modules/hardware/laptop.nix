{...}: {
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  services.clight = {
    enable = true;
    settings.backlight.disabled = true;
    settings.kbd.disabled = true;
    # Gamma/night-light not needed
    settings.gamma.disabled = true;
    settings.inhibit.inhibit_docked = true;
  };

  # geolocation required by the clight module
  # gamma not needed; sending dummy
  location.provider = "manual";
  location.latitude = 0.0;
  location.longitude = 0.0;
}
