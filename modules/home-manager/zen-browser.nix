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
    profiles.default = let
      containers = {
        Work = {
          color = "blue";
          icon = "briefcase";
          id = 1;
        };
      };
      spaces = {
        General = {
          id = "462964d0-6ad2-4569-b57c-b72eb1932a5a";
          position = 2000;
        };
        Code = {
          id = "68a9f1c2-b207-4653-af5f-5361f2950c63";
          container = containers.Work.id;
          position = 1000;
        };
        Work = {
          id = "ff7e0538-16ed-4b39-adf8-63b80796d456";
          container = containers.Work.id;
          position = 3000;
        };
      };
      pins = {
        # Essential
        "Proton Mail" = {
          id = "05b43593-77a1-43a4-aaea-b2749254be8c";
          url = "https://mail.proton.me/";
          isEssential = true;
          position = 101;
        };
        "Tailscale" = {
          id = "54c91b96-a833-4e10-b3bb-58067e840b19";
          url = "https://login.tailscale.com/admin/machines";
          isEssential = true;
          position = 102;
        };
        # General
        "ZUTOMAYO" = {
          id = "90b645f5-34e7-43c8-bc1d-2baad509f73e";
          url = "https://zutomayo.net/";
          isEssential = true;
          position = 100;
        };
        "Hacker News" = {
          id = "52d12565-27ef-43ad-89e6-6c23a2713a33";
          url = "https://news.ycombinator.com/";
          workspace = spaces.General.id;
          position = 200;
        };
        "NixOS Wiki" = {
          id = "ca939938-dc30-45b2-bb1a-5e845d4d919c";
          url = "https://nixos.wiki/wiki/Main_Page";
          workspace = spaces.General.id;
          position = 201;
        };
        # Code
        "GitHub" = {
          id = "458dfe58-7b41-4a84-a4ef-3c92f4373118";
          url = "https://github.com/";
          workspace = spaces.Code.id;
          position = 300;
        };
        # Work
        "Google Docs" = {
          id = "e532c948-ee4e-4da5-a0b0-af8e95f499d5";
          url = "https://docs.google.com/";
          workspace = spaces.Work.id;
          position = 400;
        };
      };
    in {
      extensions.packages = with inputs.firefox-addons.packages.${system}; [
        ublock-origin
        proton-pass
        refined-github
        return-youtube-dislikes
        df-youtube
      ];
      settings = {
        # Disable DNS-over-HTTPS so captive portals can
        # intercept DNS and redirect to their login page.
        "network.trr.mode" = 5;
        # Enable Firefox/Zen native captive portal detection
        "network.captive-portal-service.enabled" = true;
        "captivedetect.canonicalURL" = "http://detectportal.firefox.com/canonical.html";
      };
      containersForce = true;
      spacesForce = true;
      inherit containers spaces pins;
      search = {
        force = true;
        default = "unduck";
        engines = {
          # NixOS package search
          nixos-packages = {
            name = "NixOS Packages";
            urls = [{template = "https://search.nixos.org/packages?query={searchTerms}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@nx"];
          };
          unduck = {
            name = "Unduck";
            urls = [{template = "https://unduck.link?q={searchTerms}";}];
          };
          weblio = {
            name = "weblio";
            urls = [{template = "https://www.weblio.jp/content/{searchTerms}";}];

            definedAliases = ["@js"];
          };
          kotobank = {
            name = "コトバンク";
            urls = [{template = "https://kotobank.jp/search?q={searchTerms}";}];
            definedAliases = ["@jb"];
          };
        };
      };
    };
  };
}
