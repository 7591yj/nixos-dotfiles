{ inputs, ... }:
{
  repo.aspects.agent-skills = {
    homeModules = [ ../home-manager/agent-skills.nix ];
    homeManagerSharedModules = [ inputs.skills-catalog.homeManagerModules.default ];
  };
}
