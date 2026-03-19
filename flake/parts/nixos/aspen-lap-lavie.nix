{inputs, ...}: {
  flake.nixosConfigurations.aspen-lap-lavie = inputs.self.lib.mkNixosSystem {
    hostname = "aspen-lap-lavie";
    useStylix = true;
    useDisko = true;
    useAgentSkills = true;
    homeProfile = "u7591yj-aspen-lap-lavie";
  };
}
