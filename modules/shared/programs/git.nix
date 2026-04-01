{
  pkgs,
  inputs,
  ...
}:
let
  gitWrapper = inputs.nix-wrapper-modules.lib.evalPackage [
    { inherit pkgs; }
    (
      { wlib, ... }:
      {
        imports = [ wlib.wrapperModules.git ];

        settings = {
          user = {
            name = "7591yj";
            email = "77034308+7591yj@users.noreply.github.com";
          };
          init.defaultBranch = "main";
          core.editor = "nvim";
          sequence.editor = "nvim";
          alias = {
            br = "branch";
            ci = "commit -m ";
            co = "checkout";
            lg = "log --oneline --graph --decorate";
            st = "status";
            sw = "switch";
          };
          pull.rebase = true;
          push.autoSetupRemote = true;
        };
      }
    )
  ];
in
{
  environment.systemPackages = [
    gitWrapper
    pkgs.gh
  ];
}
