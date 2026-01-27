{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages = with pkgs; [
    # shell
    blesh
    zoxide
    starship

    lazygit
    ngrok

    # docs
    obsidian
    onlyoffice-desktopeditors
    anki-bin
    zed-editor

    # communication
    telegram-desktop
    discord

    # entertainment
    spotify
    jellyfin-desktop
    steam
    # kdePackages.kdenlive

    # gtk
    nautilus
    showtime
    loupe
    papers
    meld
    snapshot
    seahorse

    # misc
    proton-pass
    btrfs-assistant
  ];

  programs.zen-browser = {
    enable = true;
    profiles.default.extensions.packages = 
      with inputs.firefox-addons.packages.${system}; [
        ublock-origin
        dearrow
        proton-pass
        refined-github
        return-youtube-dislikes
    ];
  };
}
