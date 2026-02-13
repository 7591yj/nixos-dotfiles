{...}: {
  # Common desktop functionality shared by all display servers
  imports = [
    ./portals.nix
    ./keyring.nix
    ./polkit-agent.nix
    ./dms.nix
  ];
}
