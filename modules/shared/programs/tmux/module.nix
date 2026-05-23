inputs:
{
  wlib,
  ...
}:
{
  imports = [ wlib.wrapperModules.tmux ];

  config = {
    sourceSensible = false;
    terminal = "tmux-256color";
    terminalOverrides = ",*:RGB";
    modeKeys = "vi";
    vimVisualKeys = true;
    configAfter = builtins.readFile ./tmux.conf;
  };
}
