{ ... }:
{
  flake.modules.darwin = {
    desktop-role = import ../../../modules/darwin/roles/desktop.nix;
    darwin-template-host = import ../../../hosts/templates/darwin/default.nix;
  };
}
