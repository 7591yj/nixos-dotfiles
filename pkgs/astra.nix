{
  appimageTools,
  fetchurl,
  lib,
  stdenvNoCC,
  undmg,
}:
let
  pname = "astra";
  version = "0.8.0-beta";
in
if stdenvNoCC.hostPlatform.isDarwin then
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/Boof2015/astra/releases/download/v${version}/Astra-${version}-Mac-arm64.dmg";
      hash = "sha256-S9X95nLTF6paRimfXbrs5JVhVlOuhUkHYpj4yafS8FA=";
    };

    nativeBuildInputs = [ undmg ];
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications"
      cp -R Astra.app "$out/Applications/"

      runHook postInstall
    '';

    meta = {
      description = "Audiophile music player with advanced visualization";
      homepage = "https://github.com/Boof2015/astra";
      license = lib.licenses.gpl3Only;
      platforms = [ "aarch64-darwin" ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  }
else
  let
    src = fetchurl {
      url = "https://github.com/Boof2015/astra/releases/download/v${version}/Astra-${version}-Linux.AppImage";
      hash = "sha256-ZckQjlpS09t1PpqXYP5L8FR/Aq0tiyMgTbhNJgMwCc8=";
    };
    contents = appimageTools.extract {
      inherit pname version src;
    };
  in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm444 ${contents}/astra.png $out/share/pixmaps/astra.png
      install -Dm444 ${contents}/astra.desktop $out/share/applications/astra.desktop
      substituteInPlace $out/share/applications/astra.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=astra'
    '';

    meta = {
      description = "Audiophile music player with advanced visualization";
      homepage = "https://github.com/Boof2015/astra";
      license = lib.licenses.gpl3Only;
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  }
