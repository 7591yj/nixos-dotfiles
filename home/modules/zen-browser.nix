{
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [inputs.zen-browser.homeModules.beta];

  stylix.targets.zen-browser.profileNames = ["default"];

  programs.zen-browser = {
    enable = true;
    suppressXdgMigrationWarning = true;
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
    profiles.default = {
      extensions.packages = with inputs.firefox-addons.packages.${system}; [
        ublock-origin
        proton-pass
        refined-github
        return-youtube-dislikes
      ];
      settings = {
        # Disable DNS-over-HTTPS so captive portals can
        # intercept DNS and redirect to their login page.
        "network.trr.mode" = 5;
        # Enable Firefox/Zen native captive portal detection
        "network.captive-portal-service.enabled" = true;
        "captivedetect.canonicalURL" = "http://detectportal.firefox.com/canonical.html";
      };
    };
  };
}
