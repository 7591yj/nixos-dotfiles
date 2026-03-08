{pkgs, ...}: {
  home.packages = [
    (pkgs.callPackage ../../pkgs/t3code.nix {})
  ];
}
