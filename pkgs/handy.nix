{
  appimageTools,
  fetchurl,
  lib,
  wtype,
}:
let
  pname = "handy";
  version = "0.9.5";
  src = fetchurl {
    url = "https://github.com/cjpais/Handy/releases/download/v${version}/Handy_${version}_amd64.AppImage";
    hash = "sha256-u6HXEDrMMO8DRpcK8sHYh13zI40dZbelv1oOSKGn7Zw=";
  };
  contents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = _: [ wtype ];

  extraInstallCommands = ''
    install -Dm444 ${contents}/Handy.png $out/share/pixmaps/handy.png
    install -Dm444 ${contents}/Handy.desktop $out/share/applications/handy.desktop
  '';

  meta = {
    description = "Private, offline speech-to-text application";
    homepage = "https://github.com/cjpais/Handy";
    license = lib.licenses.mit;
    mainProgram = "handy";
    platforms = [ "x86_64-linux" ];
  };
}
