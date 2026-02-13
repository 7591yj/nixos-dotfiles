{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "7591yj";
        email = "77034308+7591yj@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      alias = {
        ci = "commit";
        sw = "switch";
        co = "checkout";
        st = "status";
        lg = "log --oneline --graph --decorate";
      };
      core.editor = "vim";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
    };
  };
}
