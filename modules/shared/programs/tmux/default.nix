{inputs, ...}: {
  imports = [ inputs.nix-wrapper-modules.nixosModules.tmux ];

  wrappers.tmux = {
    enable = true;
    sourceSensible = false;
    terminal = "xterm-kitty";
    terminalOverrides = ",xterm-kitty:RGB";
    modeKeys = "vi";
    vimVisualKeys = true;
    configAfter = builtins.readFile ./tmux.conf;
  };
}
