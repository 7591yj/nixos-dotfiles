{...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dde0enqQEqyhhFPTU7+kdbQwYQHWMfCEI="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-generations +3";
    };
  };
}
