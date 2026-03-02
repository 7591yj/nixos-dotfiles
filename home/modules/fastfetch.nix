{config, ...}: let
  esc = builtins.fromJSON ''"\u001b"'';
in {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "sixel";
        source = "/run/secrets/icon";
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
          key = "os";
          keyColor = "green";
          format = "{name}";
        }
        {
          type = "kernel";
          key = "ker";
          keyColor = "green";
        }
        {
          type = "shell";
          key = "sh";
          keyColor = "blue";
          format = "{pretty-name}";
        }
        {
          type = "wm";
          key = "wm";
          keyColor = "red";
          format = "{pretty-name}";
        }
        {
          type = "cpu";
          key = "cpu";
          keyColor = "yellow";
          format = "{name}";
        }
        {
          type = "memory";
          key = "ram";
          keyColor = "yellow";
          format = "{used} / {total}";
        }
        {
          type = "custom";
          format = "${esc}[33m󰮯  ${esc}[32m󰊠  ${esc}[34m󰊠  ${esc}[31m󰊠  ${esc}[36m󰊠  ${esc}[35m󰊠  ${esc}[37m󰊠  ${esc}[97m󰊠";
        }
      ];
    };
  };
}
