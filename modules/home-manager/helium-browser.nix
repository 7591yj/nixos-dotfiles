{ inputs, ... }:
{
  imports = [ inputs."helium-browser".homeModules.helium ];

  programs.helium = {
    enable = true;
    extensions = [
      {
        id = "ghmbeldphafepmbegfdlkpapadhbakde";
        hash = "sha256-I3IsZqbm/AlZwVd376/N1tZumBZQ6nh5q16EJnIlBV0=";
      }
      {
        id = "hlepfoohegkhhmjieoechaddaejaokhf";
        hash = "sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=";
      }
      {
        id = "gebbhagfogifgggkldgodflihgfeippi";
        hash = "sha256-0ZO+7AY5dcy1AOXPtZ9sSPcj9Wl2RQkE9oOFZq7ESqM=";
      }
      {
        id = "kchgllkpfcggmdaoopkhlkbcokngahlg";
        hash = "sha256-KNAteNPuEbw2HQpbRAnmjoc/5CxO1cBVzc8QpwRoWFc=";
      }
    ];
    extraPolicies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BrowserSignin = 0;
      DefaultBrowserSettingEnabled = false;
      DnsOverHttpsMode = "off";
      MetricsReportingEnabled = false;
      PasswordManagerEnabled = false;
      UserFeedbackAllowed = false;
      ManagedBookmarks = [
        {
          toplevel_name = "Essentials";
        }
        {
          name = "Proton Mail";
          url = "https://mail.proton.me/";
        }
        {
          name = "Tailscale";
          url = "https://login.tailscale.com/admin/machines";
        }
        {
          name = "ZUTOMAYO";
          url = "https://zutomayo.net/";
        }
        {
          name = "Hacker News";
          url = "https://news.ycombinator.com/";
        }
        {
          name = "NixOS Wiki";
          url = "https://nixos.wiki/wiki/Main_Page";
        }
        {
          name = "GitHub";
          url = "https://github.com/";
        }
        {
          name = "Google Docs";
          url = "https://docs.google.com/";
        }
      ];
    };
    preferences = {
      browser.show_home_button = false;
      bookmark_bar = {
        show_apps_shortcut = false;
        show_managed_bookmarks = true;
        show_on_all_tabs = false;
        show_tab_groups = false;
      };
    };
  };
}
