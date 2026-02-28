# ============================================================================
# home/editors/neovim.nix - Neovim Configuration
# ============================================================================
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.my.editors.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      package = pkgs.unstable.neovim-unwrapped;

      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects
        nvim-lspconfig
        fidget-nvim
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        luasnip
        cmp_luasnip
        telescope-nvim
        telescope-fzf-native-nvim
        plenary-nvim
        nvim-tree-lua
        nvim-web-devicons
        gitsigns-nvim
        vim-fugitive
        lualine-nvim
        bufferline-nvim
        indent-blankline-nvim
        catppuccin-nvim
        comment-nvim
        nvim-autopairs
        nvim-surround
        which-key-nvim
      ];

      extraLuaConfig = ''
        vim.g.mapleader = " "
        vim.g.maplocalleader = " "

        local opt = vim.opt
        opt.number = true
        opt.relativenumber = true
        opt.mouse = "a"
        opt.ignorecase = true
        opt.smartcase = true
        opt.hlsearch = true
        opt.incsearch = true
        opt.expandtab = true
        opt.shiftwidth = 2
        opt.tabstop = 2
        opt.softtabstop = 2
        opt.smartindent = true
        opt.wrap = false
        opt.cursorline = true
        opt.signcolumn = "yes"
        opt.termguicolors = true
        opt.scrolloff = 8
        opt.sidescrolloff = 8
        opt.updatetime = 250
        opt.timeoutlen = 300
        opt.splitbelow = true
        opt.splitright = true
        opt.clipboard = "unnamedplus"
        opt.undofile = true
        opt.completeopt = { "menu", "menuone", "noselect" }

        vim.cmd.colorscheme("catppuccin-mocha")

        local keymap = vim.keymap.set
        keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
        keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
        keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
        keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
        keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
        keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
        keymap("n", "<Esc>", ":noh<CR>", { silent = true })
        keymap("v", "<", "<gv")
        keymap("v", ">", ">gv")
        keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
        keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
        keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
        keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
        keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
        keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
        keymap("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })

        require("lualine").setup({ options = { theme = "catppuccin" } })
        require("gitsigns").setup()
        require("Comment").setup()
        require("nvim-autopairs").setup()
        require("nvim-surround").setup()
        require("nvim-tree").setup({ view = { width = 35 }, renderer = { group_empty = true } })
        require("telescope").setup({ defaults = { file_ignore_patterns = { "node_modules", ".git/", "target/", "dist/" } } })
        pcall(require("telescope").load_extension, "fzf")
        require("which-key").setup()
        require("ibl").setup()
        require("bufferline").setup({ options = { diagnostics = "nvim_lsp" } })
        require("fidget").setup()

        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        lspconfig.ts_ls.setup({ capabilities = capabilities })
        lspconfig.pyright.setup({ capabilities = capabilities })
        lspconfig.rust_analyzer.setup({ capabilities = capabilities })
        lspconfig.gopls.setup({ capabilities = capabilities })
        lspconfig.nil_ls.setup({ capabilities = capabilities })
        lspconfig.lua_ls.setup({ capabilities = capabilities, settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } } } })

        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local buf = args.buf
            keymap("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
            keymap("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "Go to references" })
            keymap("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "Hover docs" })
            keymap("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code action" })
            keymap("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Rename symbol" })
            keymap("n", "<leader>d", vim.diagnostic.open_float, { buffer = buf, desc = "Line diagnostics" })
          end,
        })

        local cmp = require("cmp")
        local luasnip = require("luasnip")
        cmp.setup({
          snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
              else fallback() end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then luasnip.jump(-1)
              else fallback() end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" }, { name = "path" } }, { { name = "buffer" } }),
        })
      '';
    };

    home.packages = with pkgs; [
      nodePackages.typescript-language-server
      pyright
      rust-analyzer
      gopls
      nil
      lua-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.prettier
      stylua
      nixfmt-rfc-style
    ];
  };
}
