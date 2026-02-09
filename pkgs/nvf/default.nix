{ pkgs, lib, ... }:

{
  vim = {
    clipboard = {
      enable = true;
    };

    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;

    languages = {
      enableLSP = true;
      enableTreesitter = true;

      nix.enable = true;
      ts.enable = true;
      svelte.enable = true;
      astro.enable = true;
      tailwind.enable = true;
      css.enable = true;
      rust.enable = true;
      clang.enable = true;
      markdown.enable = true;
      typst.enable = true;
      bash.enable = true;
      yaml.enable = true;
    };
  };
}
