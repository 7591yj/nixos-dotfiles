{pkgs, ...}: {
  home.packages = [
    (pkgs.callPackage ../../pkgs/astra.nix {})
  ];
}
