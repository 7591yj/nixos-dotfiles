{ ... }:
let
  common = {
    aspects = [ "userdirs" ];
    homeModules = [
      (
        { ... }:
        {
          programs.git = {
            enable = true;
            settings = {
              user = {
                name = "7591yj";
                email = "77034308+7591yj@users.noreply.github.com";
              };
              alias = {
                br = "branch";
                ci = "commit -m ";
                co = "checkout";
                lg = "log --oneline --graph --decorate";
                st = "status";
                sw = "switch";
              };
              init.defaultBranch = "main";
              core.editor = "nvim";
              sequence.editor = "nvim";
              pull.rebase = true;
              push.autoSetupRemote = true;
              credential.helper = "!gh auth git-credential";
            };
            lfs.enable = true;
          };
        }
      )
    ];
  };
in
{
  repo.users.u7591yj = common // {
    username = "u7591yj";
  };

  repo.users."7591yj" = common // {
    username = "7591yj";
  };
}
