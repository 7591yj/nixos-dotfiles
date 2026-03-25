{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # shell
    tmux
    less
  ];
}
