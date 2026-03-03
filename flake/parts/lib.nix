{inputs, ...}: {
  flake.lib = {
    mkNixosSystem = {
      hostname,
      system ? "x86_64-linux",
      nixpkgsInput ? inputs.nixpkgs,
      homeManagerInput ? inputs.home-manager,
      homeProfile ? null,
      useStylix ? false,
      useDisko ? false,
    }:
      nixpkgsInput.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules =
          [
            ({...}: {nixpkgs.config.allowUnfree = true;})
            ({pkgs, ...}: {
              nixpkgs.overlays = [
                (final: prev: {
                  inherit
                    (prev.lixPackageSets.stable)
                    nixpkgs-review
                    nix-eval-jobs
                    nix-fast-build
                    colmena
                    ;
                })
              ];
              nix.package = pkgs.lixPackageSets.stable.lix;
            })
            ../../hosts/${hostname}
          ]
          ++ (
            if useStylix
            then [inputs.stylix.nixosModules.stylix]
            else []
          )
          ++ (
            if useDisko
            then [
              inputs.disko.nixosModules.disko
              ../../hosts/${hostname}/disko.nix
            ]
            else []
          )
          ++ (
            if homeProfile != null
            then [
              homeManagerInput.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {inherit inputs;};
                  users.${homeProfile.user} =
                    import ../../home/profiles/${homeProfile.profile}.nix;
                  backupFileExtension = "backup";
                };
              }
            ]
            else []
          );
      };
  };
}
