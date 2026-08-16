{
  lib,
  pkgs,
  ...
}:
let
  requestedPackages = with pkgs; [
    # productivity
    (logseq.override {
      electron_39 = electron_41-bin;
    })

    # viewer
    iina
    readest

    # file management
    localsend

    # graphics
    imagemagick

    # security
    proton-pass

    # utils
    diffutils
    duf
    file
    p7zip
    pv
    unrar
  ];
in
{
  environment.systemPackages = builtins.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) requestedPackages;

  system.activationScripts.postActivation.text = lib.mkAfter ''
    if [ "$(launchctl managername)" = "Aqua" ]; then
      echo "refreshing LaunchServices app registrations..." >&2
      lsregister="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

      if [ -x "$lsregister" ]; then
        "$lsregister" -r -domain local -domain system -domain user >/dev/null 2>&1 || true
      fi
    fi
  '';

  homebrew = {
    enable = true;
    taps = [
      "barutsrb/tap"
    ];
    brews = [
      "ffmpeg"
      "mole"
    ];
    casks = [
      "affinity"
      "anki"
      "chatgpt"
      "element"
      "ghostty"
      "handy"
      "helium-browser"
      "jellyfin-media-player"
      "discord"
      "makemkv"
      "musicbrainz-picard"
      "omniwm"
      "onlyoffice"
      "orbstack"
      "proton-drive"
      "raycast"
      "steam"
      "tailscale-app"
      "telegram"
      "slack"
      "zed"
    ];
  };
}
