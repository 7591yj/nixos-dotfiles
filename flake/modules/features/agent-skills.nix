{ inputs, ... }:
{
  repo.featureRegistry.agent-skills = {
    homeModules = [ "agent-skills" ];
    homeManagerSharedModules = [ inputs.skills-catalog.homeManagerModules.default ];
  };
}
