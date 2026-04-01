{
  pkgs,
  inputs,
  ...
}: let
  wrapperModule = pkgs.lib.modules.importApply ./module.nix inputs;
  tmuxWrapper = inputs.nix-wrapper-modules.lib.evalPackage [
    {inherit pkgs;}
    wrapperModule
  ];
in {
  environment.systemPackages = [tmuxWrapper];
}
