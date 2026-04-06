{ ... }:
{
  repo.hosts.darwin-template = {
    enable = false;
    platform = "darwin";
    system = "aarch64-darwin";
    channel = "unstable";
    user = "u7591yj";
    aspects = [ "desktop-role" ];
    stateVersion = 6;
    homeStateVersion = "25.11";
    darwinModules = [ ../../../hosts/templates/darwin/default.nix ];
  };
}
