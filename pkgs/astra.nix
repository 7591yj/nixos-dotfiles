{
  appimageTools,
  fetchurl,
  runCommand,
}: let
  version = "0.5.0-beta";
  src = fetchurl {
    url = "https://github.com/Boof2015/astra/releases/download/v${version}/Astra-${version}-Linux.AppImage";
    hash = "sha256-wZEW7r4v5IWtXUJk5Yk1smDESzzMy0I+m3yXjsmUV1E=";
  };
  contents = appimageTools.extract {
    pname = "astra";
    inherit version src;
  };
in
  runCommand "astra-${version}" {} ''
    mkdir -p $out/bin
    cp ${src} $out/bin/astra
    chmod +x $out/bin/astra
    install -Dm444 ${contents}/astra.png $out/share/pixmaps/astra.png
    install -Dm444 ${contents}/astra.desktop $out/share/applications/astra.desktop
    substituteInPlace $out/share/applications/astra.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=astra'
  ''
