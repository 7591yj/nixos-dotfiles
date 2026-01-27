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
        s = "status";
      };
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
    };
  };
}
