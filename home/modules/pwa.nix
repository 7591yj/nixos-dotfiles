{pkgs, ...}: {
  xdg.desktopEntries.plane = {
    name = "Plane";
    exec = "helium --app=https://app.plane.so/";
    icon = "${pkgs.fetchurl {
      url = "https://plane.so/favicon/android-chrome-512x512.png";
      hash = "sha256-uzufpB7X+xagVrM1B+F0br5j9+8/+Nw6pnf785/kiMI=";
    }}";
  };
}
