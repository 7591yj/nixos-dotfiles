inputs: {
  config,
  wlib,
  pkgs,
  ...
}: let
  plugins = with pkgs.yaziPlugins; [
    full-border
    smart-enter
    mount
    chmod
    lazygit
  ];
in {
  imports = [wlib.wrapperModules.yazi];

  config = {
    aliases = ["y"];

    settings = {
      yazi = builtins.fromTOML (builtins.readFile ./yazi.toml);
      keymap = builtins.fromTOML (builtins.readFile ./keymap.toml);
      theme = {};
    };

    constructFiles.initLua = {
      output = config.generatedConfig.output;
      relPath = "${config.binName}-config/init.lua";
      content = builtins.readFile ./init.lua;
    };

    drv.postBuild = ''
      mkdir -p ${config.generatedConfig.placeholder}/plugins
      ${builtins.concatStringsSep "\n" (map (plugin: ''
        ln -sfn ${plugin} ${config.generatedConfig.placeholder}/plugins/${plugin.pname}
      '') plugins)}
    '';
  };
}
