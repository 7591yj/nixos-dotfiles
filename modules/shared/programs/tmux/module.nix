inputs:
{
  wlib,
  ...
}:
{
  imports = [ wlib.wrapperModules.tmux ];

  config = {
    sourceSensible = false;
    terminal = "xterm-kitty";
    terminalOverrides = ",xterm-kitty:RGB";
    modeKeys = "vi";
    vimVisualKeys = true;
    configAfter = builtins.readFile ./tmux.conf;
  };
}
