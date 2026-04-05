{ inputs, ... }:
{
  repo.aspects.agent-skills = {
    homeModules = [ ../../../modules/home-manager/agent-skills.nix ];
    homeManagerSharedModules = [ inputs.skills-catalog.homeManagerModules.default ];
  };
}
