{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  nixpkgs.overlays = [
    (final: prev: {
      whitesur-icon-theme = prev.whitesur-icon-theme.override {
        alternativeIcons = true;
      };
    })
  ];
  home.packages = with pkgs; [
    # version control
    git
    gh

    # shell
    alacritty-graphics

    blesh
    starship

    zoxide
    eza
    tmux
    bat
    tree
    less

    lazygit
    ngrok

    # finder
    yazi-unwrapped
    ripgrep
    fd
    fzf

    # editor
    zed-editor

    # system info
    fastfetchMinimal

    # docs
    obsidian
    onlyoffice-desktopeditors
    anki-bin

    # communication
    telegram-desktop
    discord

    # entertainment
    spotify
    jellyfin-desktop
    steam
    # kdePackages.kdenlive

    # gtk
    celluloid
    loupe
    papers
    snapshot
    seahorse

    # misc
    proton-pass
    btrfs-assistant
    localsend
    ffmpegthumbnailer
    libopenraw
    claude-code
 
    # theme
    whitesur-cursors
    whitesur-gtk-theme
    whitesur-icon-theme
  ];

  programs.zen-browser = {
    enable = true;
    profiles.default.extensions.packages = 
      with inputs.firefox-addons.packages.${system}; [
        ublock-origin
        proton-pass
        refined-github
        return-youtube-dislikes
    ];
  };
}
