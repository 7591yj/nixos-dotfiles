vim.loader.enable()

vim.g.mapleader = " "

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.autoindent = true
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.cursorline = true
vim.opt.backspace = "indent,eol,start"
vim.opt.pumblend = 10

vim.filetype.add({ extension = { mdx = "markdown.mdx" } })

pcall(vim.cmd.colorscheme, "tomorrow-night")

local map = vim.keymap.set

map("n", "<leader>cd", "<cmd>Ex<CR>", { desc = "Open Netrw" })
map("n", "<C-d>", "<C-d>zz", { desc = "Page down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up centered" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Prev search centered" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map({ "n", "v" }, "<leader>d", "\"_d", { desc = "Delete to void register" })
map("n", "Q", "<nop>", { desc = "Disable Ex mode" })
map("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
map("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Prev quickfix" })
map("n", "<leader>j", "<cmd>lnext<CR>zz", { desc = "Next location list" })
map("n", "<leader>k", "<cmd>lprev<CR>zz", { desc = "Prev location list" })
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })
map("n", "<leader>a", function() require("harpoon"):list():add() end, { desc = "Harpoon add file" })
map("n", "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, { desc = "Harpoon menu" })
map("n", "<leader>1", function() require("harpoon"):list():select(1) end, { desc = "Harpoon file 1" })
map("n", "<leader>2", function() require("harpoon"):list():select(2) end, { desc = "Harpoon file 2" })
map("n", "<leader>3", function() require("harpoon"):list():select(3) end, { desc = "Harpoon file 3" })
map("n", "<leader>4", function() require("harpoon"):list():select(4) end, { desc = "Harpoon file 4" })
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle undotree" })

local tn = {
  bg = "NONE",
  fg = "#c5c8c6",
  dark = "#1d1f21",
  dimmed = "#969896",
  red = "#cc6666",
  green = "#b5bd68",
  blue = "#81a2be",
  purple = "#b294bb",
  cyan = "#8abeb7",
}

pcall(function()
  require("snacks").setup({
    dashboard = {
      enabled = true,
      preset = {
        header = [[
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "recent_files", limit = 8, padding = 1 },
      },
    },
  })
end)

pcall(function()
  require("harpoon"):setup()
end)

pcall(function()
  require("orgmode").setup({})
end)

pcall(function()
  require("nvim-highlight-colors").setup({})
end)

pcall(function()
  require("gitsigns").setup()
end)

pcall(function()
  require("Comment").setup()
end)

pcall(function()
  require("nvim-autopairs").setup({})
end)

pcall(function()
  require("which-key").setup({})
end)

pcall(function()
  require("trouble").setup({})
end)

pcall(function()
  require("fidget").setup({})
end)

pcall(function()
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "nixfmt" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      ["markdown.mdx"] = { "prettier" },
      svelte = { "prettier" },
      typst = { "tinymist" },
    },
  })
  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(args)
      require("conform").format({ bufnr = args.buf, lsp_fallback = true, quiet = true })
    end,
  })
end)

pcall(function()
  require("lualine").setup({
    options = {
      theme = {
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
      },
    },
  })
end)

pcall(function()
  require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true },
    autotag = { enable = true },
    textobjects = {
      enable = true,
    },
  })
end)

pcall(function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    blink.setup({
      keymap = { preset = "default" },
      completion = {
        menu = { draw = { treesitter = { "lsp" } } },
        documentation = { auto_show = true },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    })
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  local servers = {
    "nixd",
    "ts_ls",
    "svelte",
    "tailwindcss",
    "html",
    "cssls",
    "clangd",
    "gopls",
    "lua_ls",
    "phpactor",
    "pyright",
    "bashls",
    "marksman",
    "tinymist",
    "yamlls",
  }

  for _, server in ipairs(servers) do
    vim.lsp.config(server, {
      capabilities = capabilities,
    })
    vim.lsp.enable(server)
  end
end)

pcall(function()
  require("lazydev").setup({})
end)

pcall(function()
  require("telescope").setup({
    defaults = {},
  })

  map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
  map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
  map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
  map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
end)

local function apply_transparency()
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatTitle", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "NONE" })
end

apply_transparency()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_transparency,
})

local function apply_transparent_winhighlight(win)
  local ok, filetype = pcall(vim.api.nvim_get_option_value, "filetype", { buf = vim.api.nvim_win_get_buf(win) })
  if not ok then
    return
  end

  if filetype == "query" or filetype == "tsplayground" then
    vim.wo[win].winhighlight =
      "Normal:NormalFloat,NormalNC:NormalFloat,EndOfBuffer:NormalFloat,SignColumn:NormalFloat,FloatBorder:FloatBorder"
  end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType", "WinEnter" }, {
  callback = function(args)
    local win = vim.api.nvim_get_current_win()
    if args.event == "BufWinEnter" and args.buf ~= vim.api.nvim_win_get_buf(win) then
      return
    end
    apply_transparent_winhighlight(win)
  end,
})
