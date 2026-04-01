{
  pkgs,
  inputs,
  ...
}: let
  wrapperModule = pkgs.lib.modules.importApply ./module.nix inputs;
  yaziWrapper = inputs.nix-wrapper-modules.lib.evalPackage [
    {inherit pkgs;}
    wrapperModule
  ];
in {
  environment.systemPackages = with pkgs; [
    yaziWrapper

    # yazi plugins
    yaziPlugins.full-border
    yaziPlugins.smart-enter
    yaziPlugins.mount
    yaziPlugins.chmod
    yaziPlugins.lazygit
  ];

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
