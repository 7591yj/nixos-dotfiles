{inputs, ...}: {
  flake.nixosConfigurations.juniper-srv-vm = inputs.self.lib.mkNixosSystem {
    hostname = "juniper-srv-vm";
    nixpkgsInput = inputs.nixpkgs-stable;
    homeManagerInput = inputs.home-manager-stable;
    useDisko = true;
    homePath = "u7591yj/juniper-srv-vm";
  };
}
