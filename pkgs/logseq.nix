{
  appimageTools,
  fetchurl,
  lib,
}:
let
  version = "0.10.14";
  pname = "logseq";
  src = fetchurl {
    url = "https://github.com/logseq/logseq/releases/download/${version}/Logseq-linux-x64-${version}.AppImage";
    hash = "1n7qp7r1pq9niphk42aw8v0mkljhlia40klbkj6n8617ym8ki5qg";
  };
in
appimageTools.wrapAppImage {
  inherit pname version src;

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -Dm644 ${contents}/usr/share/icons/hicolor/512x512/apps/logseq.png \
        $out/share/icons/hicolor/512x512/apps/logseq.png
      install -Dm644 ${contents}/usr/share/applications/logseq.desktop \
        $out/share/applications/logseq.desktop
      substituteInPlace $out/share/applications/logseq.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=logseq'
    '';

  meta = {
    description = "Privacy-first, open-source platform for knowledge management and collaboration";
    homepage = "https://github.com/logseq/logseq";
    license = lib.licenses.agpl3Only;
    mainProgram = "logseq";
    platforms = [ "x86_64-linux" ];
  };
}
