{
  pkgs,
  lib,
  ...
}: {
  stylix.targets.yazi.enable = true;

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;

    shellWrapperName = "y";

    plugins = with pkgs.yaziPlugins; {
      inherit full-border smart-enter mount chmod lazygit;
    };

    settings = {
      yazi = {
        sort_dir_first = true;
        show_hidden = true;
        show_symlink = true;
      };
      keymap = {
        mgr.prepend_keymap = [
          {
            run = "plugin smart-enter";
            on = "<Enter>";
          }
        ];
      };
      preview = {
        image_filter = "lanczos3";
        image_quality = 90;
        tab_size = 1;
        max_width = 600;
        max_height = 900;
        cache_dir = "";
        ueberzug_scale = 1;
        ueberzug_offset = [
          0
          0
          0
          0
        ];
      };
    };

    initLua = ''
      require("full-border"):setup()
    '';
  };
}
