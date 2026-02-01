{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
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

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    mkHost = {
      hostname,
      system ? "x86_64-linux",
      homeProfile ? null  # { user, profile } | null (server)
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ({ ... }: { nixpkgs.config.allowUnfree = true; })
        ./hosts/${hostname}
      ] ++ (if homeProfile != null then [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            sharedModules = [
              inputs.zen-browser.homeModules.beta
            ];
            users.${homeProfile.user} =
              import ./home/profiles/${homeProfile.profile}.nix;
            backupFileExtension = "backup";
          };
        }
      ] else []);
    };
  in
  {
    nixosConfigurations = {
      lunarlavie = mkHost {
        hostname = "lunarlavie";
        homeProfile = {
          user = "u7591yj";
          profile = "u7591yj-lunarlavie";
        };
      };

      hawknavi = mkHost {
        hostname = "hawknavi";
        # server; no homeProfile
      };
    };
  };
}
