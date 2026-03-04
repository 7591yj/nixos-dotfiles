{pkgs, ...}: {
  xdg.desktopEntries.hoppscotch = {
    name = "Hoppscotch";
    exec = "helium --app=https://hoppscotch.io/";
    icon = "${pkgs.fetchurl {
      url = "https://avatars.githubusercontent.com/u/56705483";
      hash = "sha256-o5TFUNSc7SpkgRWzeNcpy4bWxU1r9reDQzZ6SdWCMUg=";
    }}";
  };

  xdg.desktopEntries.plane = {
    name = "Plane";
    exec = "helium --app=https://app.plane.so/";
    icon = "${pkgs.fetchurl {
      url = "https://plane.so/favicon/android-chrome-512x512.png";
      hash = "sha256-uzufpB7X+xagVrM1B+F0br5j9+8/+Nw6pnf785/kiMI=";
    }}";
  };
}
