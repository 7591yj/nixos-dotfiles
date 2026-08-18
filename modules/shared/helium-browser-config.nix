let
  extensionIds = [
    "ghmbeldphafepmbegfdlkpapadhbakde"
    "hlepfoohegkhhmjieoechaddaejaokhf"
    "gebbhagfogifgggkldgodflihgfeippi"
    "kchgllkpfcggmdaoopkhlkbcokngahlg"
  ];
in
{
  policies = {
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    BookmarkBarEnabled = false;
    BrowserSignin = 0;
    DefaultBrowserSettingEnabled = false;
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderKeyword = "unduck";
    DefaultSearchProviderName = "Unduck";
    DefaultSearchProviderSearchURL = "https://unduck.link?q={searchTerms}";
    DnsOverHttpsMode = "off";
    DNSInterceptionChecksEnabled = true;
    ExtensionInstallForcelist = map (
      id: "${id};https://clients2.google.com/service/update2/crx"
    ) extensionIds;
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
        name = "General";
        children = [
          {
            name = "Hacker News";
            url = "https://news.ycombinator.com/";
          }
          {
            name = "NixOS Wiki";
            url = "https://nixos.wiki/wiki/Main_Page";
          }
        ];
      }
      {
        name = "Code";
        children = [
          {
            name = "GitHub";
            url = "https://github.com/";
          }
        ];
      }
      {
        name = "Work";
        children = [
          {
            name = "Google Docs";
            url = "https://docs.google.com/";
          }
        ];
      }
    ];
    MetricsReportingEnabled = false;
    PasswordManagerEnabled = false;
    UserFeedbackAllowed = false;
  };

  preferences = {
    browser.dns_interception_checks_enabled = true;
    browser.show_home_button = false;
    bookmark_bar = {
      show_apps_shortcut = false;
      show_managed_bookmarks = true;
      show_on_all_tabs = false;
      show_tab_groups = false;
    };
    dns_over_https.mode = "off";
  };
}
