{inputs, ...}: {
  flake.nixosConfigurations.hawknavi = inputs.self.lib.mkNixosSystem {
    hostname = "hawknavi";
    nixpkgsInput = inputs.nixpkgs-stable;
    homeManagerInput = inputs.home-manager-stable;
    useDisko = true;
    homeProfile = "u7591yj-hawknavi";
  };
}
