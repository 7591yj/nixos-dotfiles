{ ... }:
{
  repo.aspects.appimage = {
    platforms = [ "nixos" ];
    nixosModules = [
      {
        programs.appimage.enable = true;
        programs.appimage.binfmt = true;
        programs.nix-ld.enable = true;
      }
    ];
  };
}
