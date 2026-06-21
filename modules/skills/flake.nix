{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agent-skills-nix = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-best-practices = {
      url = "github:0xbigboss/claude-code";
      flake = false;
    };
    pi-config = {
      url = "github:amosblomqvist/pi-config";
      flake = false;
    };
    impeccable = {
      url = "github:pbakaus/impeccable";
      flake = false;
    };
  };

  outputs =
    {
      self,
      agent-skills-nix,
      nix-best-practices,
      pi-config,
      impeccable,
      ...
    }:
    {
      homeManagerModules.default = agent-skills-nix.homeManagerModules.default;
      sources.nix-best-practices = nix-best-practices;
      sources.pi-config = pi-config;
      sources.impeccable = impeccable;
    };
}
