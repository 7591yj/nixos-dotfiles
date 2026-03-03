{inputs, ...}: {
  flake.nixosConfigurations.hawknavi = inputs.self.lib.mkNixosSystem {
    hostname = "hawknavi";
    nixpkgsInput = inputs.nixpkgs-stable;
    homeManagerInput = inputs.home-manager-stable;
    useDisko = true;
    homeProfile = {
      user = "u7591yj";
      profile = "u7591yj-hawknavi";
    };
  };
}
