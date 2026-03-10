{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.t3code-nix.packages.${pkgs.system}.default
  ];
}
