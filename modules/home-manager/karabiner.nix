{ pkgs, ... }:
let
  config = {
    profiles = [
      {
        name = "Default profile";
        selected = true;
        virtual_hid_keyboard.keyboard_type_v2 = "ansi";
        complex_modifications.rules = [
          {
            description = "Swap Caps Lock and Left Control on the built-in keyboard";
            manipulators = [
              {
                type = "basic";
                from = {
                  key_code = "caps_lock";
                  modifiers.optional = [ "any" ];
                };
                to = [ { key_code = "left_control"; } ];
                conditions = [
                  {
                    type = "device_if";
                    identifiers = [ { is_built_in_keyboard = true; } ];
                  }
                ];
              }
              {
                type = "basic";
                from = {
                  key_code = "left_control";
                  modifiers.optional = [ "any" ];
                };
                to = [ { key_code = "caps_lock"; } ];
                conditions = [
                  {
                    type = "device_if";
                    identifiers = [ { is_built_in_keyboard = true; } ];
                  }
                ];
              }
            ];
          }
        ];
      }
    ];
  };
in
{
  xdg.configFile."karabiner/karabiner.json" = {
    force = true;
    source = (pkgs.formats.json { }).generate "karabiner.json" config;
  };
}
