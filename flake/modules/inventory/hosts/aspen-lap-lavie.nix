{ ... }:
{
  repo.hosts.aspen-lap-lavie = {
    platform = "nixos";
    system = "x86_64-linux";
    channel = "unstable";
    user = "u7591yj";
    roles = [ "desktop-role" ];
    features = [
      "agent-skills"
      "appimage"
      "disko"
      "helium-browser"
      "input-fcitx5"
      "kanata"
      "laptop-intel"
      "stylix"
      "virt-manager"
      "zen-browser"
    ];
    stateVersion = "25.11";
    homeStateVersion = "25.11";
    nixosModules = [
      "aspen-hardware"
      "aspen-host"
    ];
    diskoModule = "aspen-disko";
  };
}
