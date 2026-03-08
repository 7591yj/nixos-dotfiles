{
  appimageTools,
  fetchurl,
  runCommand,
}: let
  version = "0.0.4";
  src = fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha256-HlkQ/uPLXHh2Duamrmhp31yQqnETawQ4Ru7kg2MmpVs=";
  };
  contents = appimageTools.extract {
    pname = "t3code";
    inherit version src;
  };
in
  runCommand "t3code-${version}" {} ''
    mkdir -p $out/bin
    cp ${src} $out/bin/t3code
    chmod +x $out/bin/t3code
    install -Dm444 ${contents}/t3-code-desktop.png $out/share/pixmaps/t3code.png
    install -Dm444 ${contents}/t3-code-desktop.desktop $out/share/applications/t3code.desktop
    substituteInPlace $out/share/applications/t3code.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=t3code %U' \
      --replace-fail 'Icon=t3-code-desktop' 'Icon=t3code'
  ''
