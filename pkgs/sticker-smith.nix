{
  appimageTools,
  fetchurl,
  ffmpeg,
  lib,
  makeWrapper,
  runCommand,
}: let
  version = "0.2.0-beta.1";
  src = fetchurl {
    url = "https://github.com/7591yj/sticker-smith/releases/download/v${version}/Sticker.Smith-${version}.AppImage";
    hash = "sha256-mkXUk9k2sChBZhiVFZfecx+qfp3JoHWvZqvVIDQ9IWg=";
  };
  contents = appimageTools.extract {
    pname = "sticker-smith";
    inherit version src;
  };
in
  runCommand "sticker-smith-${version}" {
    nativeBuildInputs = [makeWrapper];
  } ''
    mkdir -p $out/bin $out/libexec

    # Wrap ffmpeg/ffprobe to clear LD_LIBRARY_PATH set by appimage-run,
    # which otherwise causes the AppImage's bundled libcrypto to be picked up
    makeWrapper ${ffmpeg}/bin/ffmpeg $out/libexec/ffmpeg --unset LD_LIBRARY_PATH
    makeWrapper ${ffmpeg}/bin/ffprobe $out/libexec/ffprobe --unset LD_LIBRARY_PATH

    cp ${src} $out/bin/.sticker-smith-wrapped
    chmod +x $out/bin/.sticker-smith-wrapped
    makeWrapper $out/bin/.sticker-smith-wrapped $out/bin/sticker-smith \
      --prefix PATH : $out/libexec
    install -Dm444 ${contents}/sticker-smith-desktop.png $out/share/pixmaps/sticker-smith.png
    install -Dm444 ${contents}/sticker-smith-desktop.desktop $out/share/applications/sticker-smith.desktop
    substituteInPlace $out/share/applications/sticker-smith.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=sticker-smith'
  ''
