{
  appimageTools,
  fetchurl,
  runCommand,
  stdenvNoCC,
  undmg,
}:
let
  pname = "pen";
  version = "1.2.17";
in
if stdenvNoCC.hostPlatform.isDarwin then
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://www.pen.dev/download/Pen-mac-arm64.dmg";
      hash = "sha256-n8vqy1d660WoPMruhk8G0NgMAoVuWY+5d3bIgGmASK8=";
    };

    nativeBuildInputs = [ undmg ];
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications"
      cp -R Pen.app "$out/Applications/"

      runHook postInstall
    '';
  }
else
  let
    src = fetchurl {
      url = "https://www.pen.dev/download/Pen-linux-x86_64.AppImage";
      hash = "sha256-eQVNZcEQmJbvyx0IoPt8IvVzCzZnIbsVkI87muHFHhk=";
    };
    contents = appimageTools.extract {
      inherit pname version src;
    };
  in
  runCommand "${pname}-${version}" { } ''
    mkdir -p $out/bin
    cp ${src} $out/bin/pen
    chmod +x $out/bin/pen
    install -Dm444 ${contents}/pen.png $out/share/pixmaps/pen.png
    install -Dm444 ${contents}/pen.desktop $out/share/applications/pen.desktop
    substituteInPlace $out/share/applications/pen.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=pen'
  ''
