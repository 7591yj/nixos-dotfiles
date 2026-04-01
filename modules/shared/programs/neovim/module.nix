inputs: {
  config,
  wlib,
  pkgs,
  ...
}: let
  tomorrow-nvim = config.nvim-lib.mkPlugin "tomorrow-nvim" (pkgs.fetchFromGitHub {
    owner = "paul-han-gh";
    repo = "tomorrow.nvim";
    rev = "1f21b13a0f8040f650c0b98f38b07364c20dfc86";
    hash = "sha256-AIFCm5s8vRte8AGYbi1qmnzpb/HKUmV3YJRc7ijWmMo=";
  });
in {
  imports = [wlib.wrapperModules.neovim];

  config = {
    settings.config_directory = ./config;
    settings.aliases = ["vim" "vi"];

    specs.core = with pkgs.vimPlugins; [
      tomorrow-nvim
      telescope-nvim
      plenary-nvim
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      vim-fugitive
      gitsigns-nvim
      comment-nvim
      nvim-autopairs
      which-key-nvim
      trouble-nvim
      lualine-nvim
      snacks-nvim
      harpoon2
      undotree
      orgmode
      nvim-highlight-colors
      nvim-lspconfig
      conform-nvim
      blink-cmp
      blink-compat
      colorful-menu-nvim
      fidget-nvim
      lazydev-nvim
      vim-sleuth
    ];
  };
}
