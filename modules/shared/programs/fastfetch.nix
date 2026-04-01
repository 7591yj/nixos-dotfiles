{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  esc = builtins.fromJSON ''"\u001b"'';
  logoPath = config.mySystem.fastfetch.logoPath;
  fastfetchWrapper = inputs.nix-wrapper-modules.lib.evalPackage [
    { inherit pkgs; }
    (
      { wlib, ... }:
      {
        imports = [ wlib.wrapperModules.fastfetch ];

        settings = {
          logo = lib.mkIf (logoPath != null) {
            type = "kitty";
            source = logoPath;
            width = 15;
            padding = {
              top = 1;
              left = 1;
              right = 2;
            };
          };
          modules = [
            "break"
            {
              type = "title";
              key = "host";
              keyColor = "green";
            }
            {
              type = "os";
              key = "os  ";
              keyColor = "green";
              format = "{name}";
            }
            {
              type = "kernel";
              key = "ker ";
              keyColor = "green";
            }
            {
              type = "shell";
              key = "sh  ";
              keyColor = "blue";
              format = "{pretty-name}";
            }
            {
              type = "wm";
              key = "wm  ";
              keyColor = "red";
              format = "{pretty-name}";
            }
            {
              type = "cpu";
              key = "cpu ";
              keyColor = "yellow";
              format = "{name}";
            }
            {
              type = "memory";
              key = "ram ";
              keyColor = "yellow";
              format = "{used} / {total}";
            }
            {
              type = "custom";
              format = "${esc}[33m󰮯  ${esc}[32m󰊠  ${esc}[34m󰊠  ${esc}[31m󰊠  ${esc}[36m󰊠  ${esc}[35m󰊠  ${esc}[37m󰊠  ${esc}[97m󰊠 ";
            }
          ];
        };
      }
    )
  ];
in
{
  options.mySystem.fastfetch.logoPath = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Runtime path to the secret image used as the fastfetch logo.";
  };

  config = {
    environment.systemPackages = [ fastfetchWrapper ];
  };
}
