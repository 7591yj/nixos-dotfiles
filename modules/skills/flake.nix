{
  inputs = {
    agent-skills-nix.url = "github:Kyure-A/agent-skills-nix";
    nix-best-practices = {
      url = "github:0xbigboss/claude-code";
      flake = false;
    };
    everything-claude-code = {
      url = "github:affaan-m/everything-claude-code";
      flake = false;
    };
    pi-config = {
      url = "github:amosblomqvist/pi-config";
      flake = false;
    };
  };

  outputs =
    {
      self,
      agent-skills-nix,
      nix-best-practices,
      everything-claude-code,
      pi-config,
      ...
    }:
    {
      homeManagerModules.default = agent-skills-nix.homeManagerModules.default;
      sources.nix-best-practices = nix-best-practices;
      sources.everything-claude-code = everything-claude-code;
      sources.pi-config = pi-config;
    };
}
