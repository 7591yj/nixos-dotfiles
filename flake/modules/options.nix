{ lib, ... }:
let
  inherit (lib) mkOption;
  types = lib.types;
in
{
  options.repo = {
    users = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              username = mkOption {
                type = types.str;
                default = name;
              };
              homeDirectory = mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              features = mkOption {
                type = types.listOf types.str;
                default = [ ];
              };
              homeModules = mkOption {
                type = types.listOf types.raw;
                default = [ ];
              };
            };
          }
        )
      );
      default = { };
    };

    hosts = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              enable = mkOption {
                type = types.bool;
                default = true;
              };
              hostname = mkOption {
                type = types.str;
                default = name;
              };
              platform = mkOption {
                type = types.enum [
                  "nixos"
                  "darwin"
                ];
              };
              system = mkOption {
                type = types.str;
              };
              channel = mkOption {
                type = types.enum [
                  "unstable"
                  "stable"
                ];
                default = "unstable";
              };
              user = mkOption {
                type = types.str;
              };
              roles = mkOption {
                type = types.listOf types.str;
                default = [ ];
              };
              features = mkOption {
                type = types.listOf types.str;
                default = [ ];
              };
              stateVersion = mkOption {
                type = types.raw;
              };
              homeStateVersion = mkOption {
                type = types.str;
              };
              nixosModules = mkOption {
                type = types.listOf types.str;
                default = [ ];
              };
              darwinModules = mkOption {
                type = types.listOf types.str;
                default = [ ];
              };
              homeModules = mkOption {
                type = types.listOf types.str;
                default = [ ];
              };
              diskoModule = mkOption {
                type = types.nullOr types.str;
                default = null;
              };
            };
          }
        )
      );
      default = { };
    };

    featureRegistry = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            platforms = mkOption {
              type = types.listOf (
                types.enum [
                  "nixos"
                  "darwin"
                ]
              );
              default = [
                "nixos"
                "darwin"
              ];
            };
            nixosModules = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
            darwinModules = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
            homeModules = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
            homeManagerSharedModules = mkOption {
              type = types.listOf types.raw;
              default = [ ];
            };
          };
        }
      );
      default = { };
    };
  };
}
