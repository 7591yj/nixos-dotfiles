{
  inputs,
  ...
}:
{
  programs.agent-skills = {
    enable = true;
    sources.local = {
      path = "${inputs.self}/modules/skills";
    };
    sources.nix-best-practices = {
      path = inputs.skills-catalog.sources.nix-best-practices;
      subdir = ".claude/skills";
      filter.nameRegex = "^nix-best-practices$";
    };
    sources.pi-config = {
      path = inputs.skills-catalog.sources.pi-config;
      subdir = "skills";
      filter.nameRegex = "^(orchestrator|pdf-reader|reddit|stop-slop)$";
    };
    sources.impeccable = {
      path = inputs.skills-catalog.sources.impeccable;
      subdir = ".pi/skills";
      filter.nameRegex = "^impeccable$";
    };

    skills = {
      enableAll = false;
      enable = [
        "nix-best-practices"
        "orchestrator"
        "pdf-reader"
        "reddit"
        "stop-slop"
        "impeccable"
        "linear-local-first-architecture"
      ];
    };

    targets = {
      codex.enable = true;
      agents.enable = true;
    };
  };
}
