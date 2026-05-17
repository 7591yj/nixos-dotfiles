{ lib, ... }:
{
  repo.aspects.userdirs.homeModules = [
    (
      { options, ... }:
      {
        xdg.enable = true;

        xdg.userDirs = {
          enable = true;
          createDirectories = true;
        }
        // lib.optionalAttrs (options.xdg.userDirs ? setSessionVariables) {
          setSessionVariables = false;
        };
      }
    )
  ];
}
