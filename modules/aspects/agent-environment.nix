{ inputs, ... }:
{
  repo.aspects.agent-environment.homeModules = [
    inputs.agent-environment.homeManagerModules.default
    { programs.agent-environment.enable = true; }
  ];
}
