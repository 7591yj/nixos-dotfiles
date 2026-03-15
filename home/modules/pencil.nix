{pkgs, ...}: {
  home.packages = [
    (pkgs.callPackage ../../pkgs/pencil.nix {})
  ];
}
