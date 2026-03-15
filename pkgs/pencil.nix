{
  appimageTools,
  fetchurl,
  runCommand,
}: let
  version = "3.1.1";
  src = fetchurl {
    url = "https://www.pencil.dev/download/Pencil-linux-x86_64.AppImage";
    hash = "sha256-CVYwQg6s3WifdaQ0hLjlTZ7AF9rMHIzrVoQNgVyqL8Q=";
  };
  contents = appimageTools.extract {
    pname = "pencil";
    inherit version src;
  };
in
  runCommand "pencil-${version}" {} ''
    mkdir -p $out/bin
    cp ${src} $out/bin/pencil
    chmod +x $out/bin/pencil
    install -Dm444 ${contents}/pencil.png $out/share/pixmaps/pencil.png
    install -Dm444 ${contents}/pencil.desktop $out/share/applications/pencil.desktop
    substituteInPlace $out/share/applications/pencil.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=pencil'
  ''
