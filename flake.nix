{
  inputs = {
    # core
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # de
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # apps
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium-browser.url = "gitlab:invra/helium";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    mkHost = {
      hostname,
      system ? "x86_64-linux",
      nixpkgsInput ? inputs.nixpkgs,
      homeManagerInput ? inputs.home-manager,
      homeProfile ? null,
      useStylix ? false,
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
            ./hosts/${hostname}
          ]
          ++ (
            if useStylix
            then [inputs.stylix.nixosModules.stylix]
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
                    import ./home/profiles/${homeProfile.profile}.nix;
                  backupFileExtension = "backup";
                };
              }
            ]
            else []
          );
      };
  in {
    nixosConfigurations = {
      lunarlavie = mkHost {
        hostname = "lunarlavie";
        useStylix = true;
        homeProfile = {
          user = "u7591yj";
          profile = "u7591yj-lunarlavie";
        };
      };

      hawknavi = mkHost {
        hostname = "hawknavi";
        nixpkgsInput = inputs.nixpkgs-stable;
        homeManagerInput = inputs.home-manager-stable;
        homeProfile = {
          user = "u7591yj";
          profile = "u7591yj-hawknavi";
        };
      };
    };
  };
}
