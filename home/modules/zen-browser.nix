{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  stylix.targets.zen-browser.profileNames = [ "default" ];

  programs.zen-browser = {
    enable = true;
    profiles.default.extensions.packages =
      with inputs.firefox-addons.packages.${system}; [
        ublock-origin
        proton-pass
        refined-github
        return-youtube-dislikes
    ];
  };
}
