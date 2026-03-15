{pkgs, ...}: {
  home.packages = [
    (pkgs.callPackage ../../pkgs/sticker-smith.nix {})
  ];
}
