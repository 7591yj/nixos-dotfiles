{pkgs, ...}: {
  xdg.desktopEntries.apple-music = {
    name = "Apple Music";
    exec = "zen-beta https://music.apple.com/jp/new";
    icon = "${pkgs.fetchurl {
      url = "https://upload.wikimedia.org/wikipedia/commons/5/5f/Apple_Music_icon.svg";
      hash = "sha256-4Xw8etULegsrfbreFJNRgzjHZ2bAUTq9hPYV0cUEgVM=";
    }}";
  };
}
