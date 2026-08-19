{
  appimageTools,
  fetchurl,
  runCommand,
}:
let
  version = "1.2.5";
  src = fetchurl {
    url = "https://www.pen.dev/download/Pen-linux-x86_64.AppImage";
    hash = "sha256-EtLWHAKr04AQR8VC201abVj3/uwSSxEAP7/3KoYPsWA=";
  };
  contents = appimageTools.extract {
    pname = "pen";
    inherit version src;
  };
in
runCommand "pen-${version}" { } ''
  mkdir -p $out/bin
  cp ${src} $out/bin/pen
  chmod +x $out/bin/pen
  install -Dm444 ${contents}/pen.png $out/share/pixmaps/pen.png
  install -Dm444 ${contents}/pen.desktop $out/share/applications/pen.desktop
  substituteInPlace $out/share/applications/pen.desktop \
    --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=pen'
''
