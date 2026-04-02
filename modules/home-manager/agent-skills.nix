{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = [
    (pkgs.writeShellScriptBin "setup-ecc" ''
      set -euo pipefail
      ECC="${inputs.skills-catalog.sources.everything-claude-code}"
      DEST="''${1:-.}"
      echo "Setting up everything-claude-code in $DEST..."
      mkdir -p "$DEST/.claude/commands" "$DEST/.claude/agents"
      [ -d "$ECC/commands" ] && cp -rn "$ECC/commands/." "$DEST/.claude/commands/"
      [ -d "$ECC/agents" ]   && cp -rn "$ECC/agents/."   "$DEST/.claude/agents/"
      [ -d "$ECC/.claude" ]  && cp -rn "$ECC/.claude/."  "$DEST/.claude/"
      if [ -d "$ECC/.codex" ]; then
        mkdir -p "$DEST/.codex"
        cp -rn "$ECC/.codex/." "$DEST/.codex/"
      fi
      echo "Done. Restart Claude Code / Codex in this directory."
    '')
  ];

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

    skills = {
      enableAll = false;
      enable = [
        "nix-best-practices"
      ];
    };

    targets = {
      codex.enable = true;
      claude.enable = true;
    };
  };
}
