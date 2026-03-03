{inputs, ...}: {
  flake.nixosConfigurations.lunarlavie = inputs.self.lib.mkNixosSystem {
    hostname = "lunarlavie";
    useStylix = true;
    useDisko = true;
    homeProfile = {
      user = "u7591yj";
      profile = "u7591yj-lunarlavie";
    };
  };
}
