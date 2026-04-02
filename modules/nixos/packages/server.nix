{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # shell
    less
  ];
}
