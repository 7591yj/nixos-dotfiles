{pkgs, ...}: {
  xdg.desktopEntries.plane = {
    name = "Plane";
    exec = "helium --app=https://app.plane.so/";
    icon = "${pkgs.fetchurl {
      url = "https://plane.so/favicon/android-chrome-512x512.png";
      hash = "sha256-4Xw8etULegsrfbreFJNRgzjHZ2bAUTq9hPYV0cUEgVM=";
    }}";
  };
}
