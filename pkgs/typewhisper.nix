{
  fetchurl,
  lib,
  stdenvNoCC,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "typewhisper";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/TypeWhisper/typewhisper-mac/releases/download/v${finalAttrs.version}/TypeWhisper-v${finalAttrs.version}.dmg";
    hash = "sha256-sLDVN9l+0zz5islwe36yimX9GAz+6OiUPKIj+PrUZBM=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R "TypeWhisper.app" "$out/Applications/"

    runHook postInstall
  '';

  meta = {
    description = "Local-first dictation app for macOS";
    homepage = "https://github.com/TypeWhisper/typewhisper-mac";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
