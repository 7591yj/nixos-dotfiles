{inputs, ...}: {
  flake.nixosConfigurations.aspen-lap-lavie = inputs.self.lib.mkNixosSystem {
    hostname = "aspen-lap-lavie";
    useStylix = true;
    useDisko = true;
    useAgentSkills = true;
    homePath = "u7591yj/aspen-lap-lavie";
  };
}
