{pkgs, config, ...}: let
  u = config.mySystem.username;

  yaziConfig = pkgs.runCommand "yazi-config" {} ''
    mkdir -p $out
    cp ${./yazi.toml}    $out/yazi.toml
    cp ${./keymap.toml}  $out/keymap.toml
    cp ${./theme.toml}   $out/theme.toml
    cp ${./init.lua}     $out/init.lua
  '';
in {
  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "y" ''
      exec ${pkgs.yazi}/bin/yazi "$@"
    '')
    yazi

    # yazi plugins
    yaziPlugins.full-border
    yaziPlugins.smart-enter
    yaziPlugins.mount
    yaziPlugins.chmod
    yaziPlugins.lazygit
  ];

  environment.variables.YAZI_CONFIG_HOME = "${yaziConfig}";

  # yazi shell integration
  programs.bash.interactiveShellInit = ''
    function y() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
      fi
      rm -f -- "$tmp"
    }
  '';
}
