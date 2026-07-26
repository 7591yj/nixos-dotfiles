{
  config,
  lib,
  options,
  ...
}:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;
      trusted-users = [
        "root"
        config.mySystem.username
      ];
      fallback = true;
      "narinfo-cache-positive-ttl" = 3600;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://zed.cachix.org"
        "https://cache.numtide.com"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dde0enqQEqyhhFPTU7+kdbQwYQHWMfCEI="
        "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    }
    // lib.optionalAttrs (options.nix.gc ? interval) {
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
    }
    // lib.optionalAttrs (!(options.nix.gc ? interval) && options.nix.gc ? dates) {
      dates = "Sun 00:00";
    };
  };
}
