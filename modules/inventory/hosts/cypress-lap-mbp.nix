{ ... }:
{
  repo.hosts.cypress-lap-mbp = {
    platform = "darwin";
    system = "aarch64-darwin";
    channel = "unstable";
    user = "7591yj";
    aspects = [
      "desktop-role"
      "agent-environment"
      "handy"
      "helium-browser"
      "stylix"
      "zen-browser"
    ];
    stateVersion = 6;
    homeStateVersion = "25.11";
    darwinModules = [ ../../../hosts/cypress-lap-mbp/default.nix ];
    homeModules = [ ../../../hosts/cypress-lap-mbp/zen-browser.nix ];
  };
}
