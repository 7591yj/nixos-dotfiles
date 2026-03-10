{inputs, ...}: {
  flake.nixosConfigurations.lunarlavie = inputs.self.lib.mkNixosSystem {
    hostname = "lunarlavie";
    useStylix = true;
    useDisko = true;
    homeProfile = "u7591yj-lunarlavie";
  };
}
