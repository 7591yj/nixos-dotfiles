{ ... }:
{
  repo.aspects.userdirs.homeModules = [
    {
      xdg.enable = true;

      xdg.userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = false;
      };
    }
  ];
}
