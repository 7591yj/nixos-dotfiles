{pkgs, ...}: {
  home.packages = [pkgs.blesh];

  xdg.configFile."blesh/init.sh".text = ''
    # Tomorrow Night
    # editing
    ble-face -s region                 fg=231,bg=#373b41
    ble-face -s region_insert          fg=#81a2be,bg=254
    ble-face -s region_match           fg=#1d1f21,bg=#f0c674

    # syntax
    ble-face -s syntax_command         fg=#81a2be
    ble-face -s syntax_expr            fg=#81a2be
    ble-face -s syntax_varname         fg=#de935f
    ble-face -s syntax_quoted          fg=#b5bd68
    ble-face -s syntax_quotation       fg=#b5bd68,bold
    ble-face -s syntax_escape          fg=#b294bb
    ble-face -s syntax_param_expansion fg=#b294bb
    ble-face -s syntax_function_name   fg=#b5bd68,bold
    ble-face -s syntax_glob            fg=#cc6666,bold
    ble-face -s syntax_brace           fg=#8abeb7,bold
    ble-face -s syntax_tilde           fg=#8abeb7,bold
    ble-face -s syntax_document        fg=#b5bd68
    ble-face -s syntax_document_begin  fg=#b5bd68,bold
    ble-face -s syntax_error           bg=#cc6666,fg=231
    ble-face -s syntax_comment         fg=#969896

    # commands
    ble-face -s command_keyword        fg=#b294bb
    ble-face -s command_builtin        fg=#cc6666
    ble-face -s command_builtin_dot    fg=#cc6666,bold
    ble-face -s command_alias          fg=#8abeb7
    ble-face -s command_function       fg=#b5bd68
    ble-face -s command_file           fg=#b5bd68
    ble-face -s command_jobs           fg=#cc6666
    ble-face -s command_directory      fg=#8abeb7,underline

    # filenames
    ble-face -s filename_directory     underline,fg=#8abeb7
    ble-face -s filename_link          underline,fg=#8abeb7
    ble-face -s filename_executable    underline,fg=#b5bd68
    ble-face -s filename_url           underline,fg=#81a2be

    # variable names
    ble-face -s varname_array          fg=#de935f,bold
    ble-face -s varname_empty          fg=#969896
    ble-face -s varname_export         fg=#cc6666,bold
    ble-face -s varname_expr           fg=#b294bb,bold
    ble-face -s varname_hash           fg=#b5bd68,bold
    ble-face -s varname_number         fg=#de935f
    ble-face -s varname_readonly       fg=#cc6666
    ble-face -s varname_unset          fg=#969896

    # arguments
    ble-face -s argument_option        fg=#8abeb7

    # completion
    ble-face -s auto_complete          fg=#969896,bg=254

    # Completion faces are defined at end of core-complete.sh
    function my/theme/menu-faces {
      ble-face -s menu_filter_fixed    bold
      ble-face -s menu_filter_input    fg=16,bg=#f0c674
    }
    blehook complete_load+=my/theme/menu-faces
  '';

  programs.bash = {
    enable = true;

    shellAliases = {
      ls = "eza --color=auto";
      ll = "eza -al --color=auto";
      grep = "grep --color=auto";

      lg = "lazygit";
      gcl = "git clone";
      gs = "git switch";
      gA = "git add .";
      gp = "git pull origin main";
      gP = "git push origin main";
    };

    initExtra = ''
      [[ $- != *i* ]] && return

      source -- "${pkgs.blesh}/share/blesh/ble.sh" --attach=none

      if [[ $- == *i* ]]; then # in interactive session
        set -o vi
      fi

      nixx() {
        nixos-rebuild --sudo switch -L --flake "$HOME/nixos-dotfiles#$(hostname)"
      }

      eval "$(starship init bash)"
      eval "$(zoxide init bash)"

      fastfetch

      [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';
  };
}
