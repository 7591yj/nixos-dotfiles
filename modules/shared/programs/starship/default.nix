{ pkgs, ... }:
let
  starshipConfig = pkgs.writeText "starship.toml" (builtins.readFile ./starship.toml);
in
{
  environment.systemPackages = [ pkgs.starship ];
  environment.variables.STARSHIP_CONFIG = "${starshipConfig}";
}
