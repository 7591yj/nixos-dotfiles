{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.mySystem.displayServer == "x11") {
    # https://codeberg.org/takagemacoed/xlibre-overlay (dev-for-26.05)
    nixpkgs.overlays = [
      (final: prev: {
        xorg =
          prev.xorg
          // {
            xorgserver = prev.xorg.xorgserver.overrideAttrs (_old: {
              pname = "xlibre-xserver";
              version = "25.1.2";
              src = prev.fetchurl {
                url = "https://github.com/X11Libre/xserver/archive/refs/tags/xlibre-xserver-25.1.2.tar.gz";
                sha256 = "sha256-pewjGueNAKq37arwbWwi+68gcur21mmof0kcRF789X0=";
              };
              patches = [];
            });
          };
      })
    ];

    environment.systemPackages = [pkgs.xss-lock];

    services.xserver = {
      enable = true;
      # Keep the X server alive across session resets;
      # XLibre dropped -noreset/-terminate flags
      # some display managers still expect the server
      # while handling login/session transitions
      terminateOnReset = false;
      dpi = 100;
      autoRepeatDelay = 200;
      autoRepeatInterval = 28;
      displayManager.startx = {
        enable = true;
        generateScript = true;
        extraCommands = ''
          export GTK_IM_MODULE=fcitx
          export QT_IM_MODULE=fcitx
          export XMODIFIERS=@im=fcitx
          export SDL_IM_MODULE=fcitx
          systemctl --user import-environment PATH DISPLAY XAUTHORITY DESKTOP_SESSION XDG_CONFIG_DIRS XDG_DATA_DIRS XDG_RUNTIME_DIR XDG_SESSION_ID DBUS_SESSION_BUS_ADDRESS XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE GTK_IM_MODULE QT_IM_MODULE XMODIFIERS SDL_IM_MODULE || true
          ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all || true
        '';
      };
      desktopManager.runXdgAutostartIfNone = true;
      windowManager.oxwm.enable = true;
    };

    services.displayManager.defaultSession = "none+oxwm";
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-session --asterisks --user-menu --xsessions /run/current-system/sw/share/xsessions --xsession-wrapper '${pkgs.xinit}/bin/startx ${lib.getExe' pkgs.coreutils "env"}'";
        };
      };
    };

    services.libinput = {
      enable = true;
      mouse.naturalScrolling = true;
      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
      };
    };

    systemd.user.services.xdg-desktop-portal.serviceConfig.Environment = [
      "DISPLAY=:0"
      "XAUTHORITY=%h/.Xauthority"
      "XDG_CURRENT_DESKTOP=OXWM"
      "XDG_SESSION_DESKTOP=OXWM"
      "XDG_SESSION_TYPE=x11"
    ];

    systemd.user.services.xdg-desktop-portal-gtk.serviceConfig.Environment = [
      "DISPLAY=:0"
      "XAUTHORITY=%h/.Xauthority"
      "XDG_CURRENT_DESKTOP=OXWM"
      "XDG_SESSION_DESKTOP=OXWM"
      "XDG_SESSION_TYPE=x11"
    ];

    systemd.user.services.polkit-gnome-authentication-agent-1.serviceConfig.Environment = [
      "DISPLAY=:0"
      "XAUTHORITY=%h/.Xauthority"
      "XDG_CURRENT_DESKTOP=OXWM"
      "XDG_SESSION_DESKTOP=OXWM"
      "XDG_SESSION_TYPE=x11"
    ];

    security.pam.services.greetd.enableGnomeKeyring = true;
    programs.slock.enable = true;

    systemd.user.services.xss-lock = {
      description = "X11 screen locker bridge for suspend and idle";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.xss-lock} --transfer-sleep-lock -- ${lib.getExe config.programs.slock.package}";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
