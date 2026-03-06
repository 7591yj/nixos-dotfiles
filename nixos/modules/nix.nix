{...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;
      trusted-users = ["root" "u7591yj"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://zed.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dde0enqQEqyhhFPTU7+kdbQwYQHWMfCEI="
        "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-generations +3";
    };
  };
}
