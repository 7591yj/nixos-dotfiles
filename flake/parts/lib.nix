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
      extraModules ? [],
    }:
      nixpkgsInput.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules =
          [
            {nixpkgs.hostPlatform = system;}
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
          ++ extraModules
          ++ (
            if homeProfile != null
            then [
              homeManagerInput.nixosModules.home-manager
              ({config, ...}: {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {inherit inputs;};
                  users.${config.mySystem.username} =
                    import ../../home/profiles/${homeProfile}.nix;
                  backupFileExtension = "backup";
                };
              })
            ]
            else []
          );
      };
  };
}
