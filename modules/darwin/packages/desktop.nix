{
  lib,
  pkgs,
  ...
}:
let
  requestedPackages = with pkgs; [
    # developer
    zed-editor

    # productivity
    logseq

    # viewer
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
      "typewhisper/tap"
    ];
    brews = [
      "mole"
      "pi-coding-agent"
    ];
    casks = [
      "affinity"
      "anki"
      "codex"
      "cursor"
      "element"
      "ghostty"
      "jellyfin-media-player"
      "legcord"
      "omniwm"
      "onlyoffice"
      "raycast"
      "steam"
      "t3-code"
      "tailscale-app"
      "telegram"
      "typewhisper"
      "unity-hub"
      "zoom"
    ];
  };
}
