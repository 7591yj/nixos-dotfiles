{
  stdenv,
  lib,
  fetchurl,
  buildFHSEnv,
  alsa-lib,
  at-spi2-atk,
  atk,
  autoPatchelfHook,
  cairo,
  curl,
  dbus,
  dconf,
  dpkg,
  fontconfig,
  gcc-unwrapped,
  gdk-pixbuf,
  glib,
  glibc,
  gsettings-desktop-schemas,
  gst_all_1,
  gtk2,
  gtk3,
  libnotify,
  libpulseaudio,
  libudev0-shim,
  libdrm,
  makeWrapper,
  libgbm,
  nspr,
  nss,
  pulseaudio,
  qt5,
  wrapGAppsHook3,
  xkeyboard_config,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  libxcb,
  extraFonts ? [ ],
}:
let
  runtimeLibs = lib.makeLibraryPath [
    curl
    glibc
    gcc-unwrapped.lib
    libudev0-shim
    pulseaudio
  ];

  derivation = stdenv.mkDerivation rec {
    pname = "onlyoffice-desktopeditors";
    version = "9.1.0";
    minor = null;

    src = fetchurl {
      url = "https://github.com/ONLYOFFICE/DesktopEditors/releases/download/v${version}/onlyoffice-desktopeditors_amd64.deb";
      hash = "sha256-D36E7hYCTJ9Lw9XnB8nxMGMJDJRhM+K+bviuM9uuzhk=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
      wrapGAppsHook3
    ];

    buildInputs = [
      alsa-lib
      at-spi2-atk
      atk
      cairo
      dbus
      dconf
      fontconfig
      gdk-pixbuf
      glib
      gsettings-desktop-schemas
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer
      gtk2
      gtk3
      libnotify
      libpulseaudio
      libdrm
      nspr
      nss
      libgbm
      qt5.qtbase
      qt5.qtdeclarative
      qt5.qtsvg
      qt5.qtwayland
      libx11
      libxcb
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxrender
      libxscrnsaver
      libxtst
    ];

    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,lib,share}

      mv usr/bin/* $out/bin
      mv usr/share/* $out/share/
      mv opt/onlyoffice/desktopeditors $out/share

      mkdir -p $out/share/desktopeditors/fonts/custom
      for fontPkg in ${lib.escapeShellArgs (map toString extraFonts)}; do
        if [ -d "$fontPkg/share/fonts" ]; then
          find "$fontPkg/share/fonts" -type f \
            \( -iname '*.ttf' -o -iname '*.otf' -o -iname '*.ttc' \) \
            -exec cp -t $out/share/desktopeditors/fonts/custom {} +
        fi
      done

      for f in $out/share/desktopeditors/asc-de-*.png; do
        size=$(basename "$f" ".png" | cut -d"-" -f3)
        res="''${size}x''${size}"
        mkdir -pv "$out/share/icons/hicolor/$res/apps"
        ln -s "$f" "$out/share/icons/hicolor/$res/apps/onlyoffice-desktopeditors.png"
      done

      substituteInPlace $out/bin/onlyoffice-desktopeditors \
        --replace-fail "/opt/onlyoffice/" "$out/share/"

      ln -s $out/share/desktopeditors/DesktopEditors $out/bin/DesktopEditors

      runHook postInstall
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
        --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
        --set QTCOMPOSE "${libx11.out}/share/X11/locale" \
        --set QT_QPA_PLATFORM "xcb"
      )
    '';
  };
in
buildFHSEnv {
  inherit (derivation) pname version;

  targetPkgs = pkgs': [
    curl
    derivation
  ];

  runScript = "/bin/onlyoffice-desktopeditors";

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${derivation}/share/icons $out/share
    cp -r ${derivation}/share/applications $out/share
    substituteInPlace $out/share/applications/onlyoffice-desktopeditors.desktop \
      --replace-fail "/usr/bin/onlyoffice-desktopeditors" "$out/bin/onlyoffice-desktopeditors"
  '';

  meta = {
    description = "Office suite that combines text, spreadsheet and presentation editors allowing to create, view and edit local documents";
    homepage = "https://www.onlyoffice.com/";
    downloadPage = "https://github.com/ONLYOFFICE/DesktopEditors/releases";
    changelog = "https://github.com/ONLYOFFICE/DesktopEditors/blob/master/CHANGELOG.md";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.agpl3Plus;
  };
}
