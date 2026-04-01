{
  pkgs,
  lib,
  inputs,
  ...
}: let
  wrapperModule = pkgs.lib.modules.importApply ./module.nix inputs;
  neovimWrapper = inputs.nix-wrapper-modules.lib.evalModule wrapperModule;
in {
  environment.systemPackages =
    [
      (neovimWrapper.config.wrap {inherit pkgs;})

      pkgs.nixd
      pkgs.nixfmt
      pkgs.typescript-language-server
      pkgs.svelte-language-server
      pkgs.tailwindcss-language-server
      pkgs.vscode-langservers-extracted
      pkgs.clang-tools
      pkgs.gopls
      pkgs.lua-language-server
      pkgs.stylua
      pkgs.phpactor
      pkgs.pyright
      pkgs.bash-language-server
      pkgs.marksman
      pkgs.tinymist
      pkgs.yaml-language-server
      pkgs.prettier
      pkgs.tree-sitter
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.wl-clipboard
    ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
