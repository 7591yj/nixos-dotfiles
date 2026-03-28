{pkgs, ...}: {
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "7591yj";
        email = "77034308+7591yj@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      alias = {
        br = "branch";
        ci = "commit -m ";
        co = "checkout";
        lg = "log --oneline --graph --decorate";
        st = "status";
        sw = "switch";
      };
      code.editor = "vim";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  environment.systemPackages = [
    pkgs.gh
  ];
}
