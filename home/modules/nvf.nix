{
  pkgs,
  lib,
  inputs,
  ...
}: let
  tomorrow-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "tomorrow-nvim";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "paul-han-gh";
      repo = "tomorrow.nvim";
      rev = "1f21b13a0f8040f650c0b98f38b07364c20dfc86";
      hash = "sha256-AIFCm5s8vRte8AGYbi1qmnzpb/HKUmV3YJRc7ijWmMo=";
    };
  };
in {
  imports = [inputs.nvf.homeManagerModules.default];

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        globals.mapleader = " ";

        clipboard.enable = true;

        options = {
          shiftwidth = 4;
          tabstop = 4;
          autoindent = true;
          signcolumn = "yes";
          splitbelow = true;
          splitright = true;
          termguicolors = true;
          updatetime = 50;
          mouse = "a";
        };

        searchCase = "smart";
        preventJunkFiles = true;
        undoFile.enable = true;
        syntaxHighlighting = true;

        # Theme (tomorrow-night via extraPlugins)
        theme.enable = lib.mkForce false;

        # Statusline
        statusline.lualine = {
          enable = true;
          theme = lib.mkForce "Tomorrow";
        };
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;

        treesitter = {
          enable = true;
          autotagHtml = true;
        };

        git = {
          enable = true;
          vim-fugitive.enable = true;
          gitsigns.enable = true;
        };

        comments.comment-nvim.enable = true;
        autopairs.nvim-autopairs.enable = true;
        binds.whichKey.enable = true;

        lsp = {
          enable = true;
          formatOnSave = true;
          lspkind.enable = true;
          lightbulb.enable = true;
          lspSignature.enable = true;
          trouble.enable = true;
        };

        languages = {
          enableTreesitter = true;
          enableFormat = true;

          nix.enable = true;
          ts.enable = true;
          svelte.enable = true;
          astro.enable = true;
          tailwind.enable = true;
          css.enable = true;
          html = {
            enable = true;
            # superhtml is broken in nixpkgs (sandbox violation)
            format.enable = false;
            lsp.enable = false;
          };
          json.enable = true;
          rust.enable = true;
          clang.enable = true;
          zig = {
            enable = true;
            # zls is broken in nixpkgs (sandbox violation)
            lsp.enable = false;
          };
          go.enable = true;
          lua.enable = true;
          php.enable = true;
          python.enable = true;
          haskell.enable = true;
          bash.enable = true;
          markdown.enable = true;
          typst.enable = true;
          yaml.enable = true;
        };

        extraPlugins = {
          tomorrow-nvim = {
            package = tomorrow-nvim;
            setup = ''
              require('tomorrow').setup({
                style = "night",
                transparent = true,
              })
              vim.cmd[[colorscheme tomorrow-night]]
            '';
          };

          harpoon = {
            package = pkgs.vimPlugins.harpoon2;
            setup = "require('harpoon'):setup()";
          };

          undotree = {
            package = pkgs.vimPlugins.undotree;
          };

          orgmode = {
            package = pkgs.vimPlugins.orgmode;
            setup = "require('orgmode').setup({})";
          };

          highlight-colors = {
            package = pkgs.vimPlugins.nvim-highlight-colors;
            setup = "require('nvim-highlight-colors').setup({})";
          };

          snacks = {
            package = pkgs.vimPlugins.snacks-nvim;
            setup = ''
                           require('snacks').setup({
                             dashboard = {
                               enabled = true,
                               preset = {
                                 header = [[
              ███╗   ██╗██╗   ██╗██╗███╗   ███╗
              ████╗  ██║██║   ██║██║████╗ ████║
              ██╔██╗ ██║██║   ██║██║██╔████╔██║
              ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
              ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
              ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]],
                               },
                               sections = {
                                 { section = "header" },
                                 { section = "keys", gap = 1, padding = 1 },
                                 { section = "recent_files", limit = 8, padding = 1 },
                               },
                             },
                           })
            '';
          };
        };

        keymaps = [
          {
            key = "<leader>cd";
            mode = "n";
            action = "<cmd>Ex<CR>";
            desc = "Open Netrw";
          }

          # Centered scrolling
          {
            key = "<C-d>";
            mode = "n";
            action = "<C-d>zz";
            desc = "Page down centered";
          }
          {
            key = "<C-u>";
            mode = "n";
            action = "<C-u>zz";
            desc = "Page up centered";
          }
          {
            key = "n";
            mode = "n";
            action = "nzzzv";
            desc = "Next search centered";
          }
          {
            key = "N";
            mode = "n";
            action = "Nzzzv";
            desc = "Prev search centered";
          }

          # Move lines in visual mode
          {
            key = "J";
            mode = "v";
            action = ":m '>+1<CR>gv=gv";
            desc = "Move selection down";
          }
          {
            key = "K";
            mode = "v";
            action = ":m '<-2<CR>gv=gv";
            desc = "Move selection up";
          }

          # Clipboard operations
          {
            key = "<leader>p";
            mode = "x";
            action = "\"_dP";
            desc = "Paste without overwriting clipboard";
          }
          {
            key = "<leader>d";
            mode = "n";
            action = "\"_d";
            desc = "Delete to void register";
          }
          {
            key = "<leader>d";
            mode = "v";
            action = "\"_d";
            desc = "Delete to void register";
          }
          {
            key = "<leader>y";
            mode = "n";
            action = "\"+y";
            desc = "Yank to system clipboard";
          }
          {
            key = "<leader>y";
            mode = "v";
            action = "\"+y";
            desc = "Yank to system clipboard";
          }

          # Disable Ex mode
          {
            key = "Q";
            mode = "n";
            action = "<nop>";
            desc = "Disable Ex mode";
          }

          # Quickfix navigation
          {
            key = "<C-j>";
            mode = "n";
            action = "<cmd>cnext<CR>zz";
            desc = "Next quickfix";
          }
          {
            key = "<C-k>";
            mode = "n";
            action = "<cmd>cprev<CR>zz";
            desc = "Prev quickfix";
          }
          {
            key = "<leader>j";
            mode = "n";
            action = "<cmd>lnext<CR>zz";
            desc = "Next location list";
          }
          {
            key = "<leader>k";
            mode = "n";
            action = "<cmd>lprev<CR>zz";
            desc = "Prev location list";
          }

          # Replace word under cursor
          {
            key = "<leader>s";
            mode = "n";
            action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
            desc = "Replace word under cursor";
          }

          # Harpoon
          {
            key = "<leader>a";
            mode = "n";
            action = "<cmd>lua require('harpoon'):list():add()<CR>";
            desc = "Harpoon add file";
          }
          {
            key = "<C-e>";
            mode = "n";
            action = "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>";
            desc = "Harpoon menu";
          }
          {
            key = "<leader>1";
            mode = "n";
            action = "<cmd>lua require('harpoon'):list():select(1)<CR>";
            desc = "Harpoon file 1";
          }
          {
            key = "<leader>2";
            mode = "n";
            action = "<cmd>lua require('harpoon'):list():select(2)<CR>";
            desc = "Harpoon file 2";
          }
          {
            key = "<leader>3";
            mode = "n";
            action = "<cmd>lua require('harpoon'):list():select(3)<CR>";
            desc = "Harpoon file 3";
          }
          {
            key = "<leader>4";
            mode = "n";
            action = "<cmd>lua require('harpoon'):list():select(4)<CR>";
            desc = "Harpoon file 4";
          }

          # Undotree
          {
            key = "<leader>u";
            mode = "n";
            action = "<cmd>UndotreeToggle<CR>";
            desc = "Toggle undotree";
          }
        ];

        luaConfigPost = ''
          vim.opt.number = true
          vim.opt.relativenumber = true
          vim.opt.scrolloff = 8
          vim.opt.colorcolumn = "80"
          vim.opt.hlsearch = false
          vim.opt.incsearch = true
          vim.opt.cursorline = true
          vim.opt.backspace = "indent,eol,start"
          -- Slight transparency for floating windows
          vim.o.winblend = 10
          vim.o.pumblend = 10

          -- Custom lualine theme (tomorrow-night palette)
          local tn = {
            bg      = "NONE",
            fg      = "#c5c8c6",
            dark    = "#1d1f21",
            grey    = "#373b41",
            dimmed  = "#969896",
            red     = "#cc6666",
            green   = "#b5bd68",
            yellow  = "#f0c674",
            blue    = "#81a2be",
            purple  = "#b294bb",
            cyan    = "#8abeb7",
          }
          local custom_lualine = {
            normal = {
              a = { fg = tn.dark, bg = tn.blue, gui = "bold" },
              b = { fg = tn.fg, bg = tn.dark },
              c = { fg = tn.dimmed, bg = tn.bg },
            },
            insert = {
              a = { fg = tn.dark, bg = tn.green, gui = "bold" },
            },
            visual = {
              a = { fg = tn.dark, bg = tn.purple, gui = "bold" },
            },
            replace = {
              a = { fg = tn.dark, bg = tn.red, gui = "bold" },
            },
            command = {
              a = { fg = tn.dark, bg = tn.dark, gui = "bold" },
            },
            terminal = {
              a = { fg = tn.dark, bg = tn.cyan, gui = "bold" },
            },
            inactive = {
              a = { fg = tn.dimmed, bg = tn.bg },
              b = { fg = tn.dimmed, bg = tn.bg },
              c = { fg = tn.dimmed, bg = tn.bg },
            },
          }
          require('lualine').setup({ options = { theme = custom_lualine } })

          -- Transparent backgrounds (must be last to override everything)
          local clear_bg = { bg = "NONE" }
          local groups = {
            "Normal", "NormalNC", "NormalFloat", "SignColumn",
            "LineNr", "CursorLineNr", "EndOfBuffer", "FoldColumn",
            "Folded", "WinSeparator", "VertSplit",
            "StatusLine", "StatusLineNC",
          }
          for _, group in ipairs(groups) do
            vim.api.nvim_set_hl(0, group, clear_bg)
          end
        '';
      };
    };
  };
}
