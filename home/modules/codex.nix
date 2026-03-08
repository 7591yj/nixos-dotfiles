{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.codex-nix.packages.${pkgs.system}.default
  ];
}
