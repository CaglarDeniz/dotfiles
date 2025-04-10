-- Basic options
vim.opt.number = true
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.hidden = true


-- Enable true color support
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1

-- Set leader key
vim.g.mapleader = " "

-- Bootstrap lazy.nvim (modern plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup with lazy.nvim
require("lazy").setup({

	-- Easy parenthesis and quote matching
	{ 'echasnovski/mini.pairs', version = false },

	-- Remember your keybinds!
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
},

	-- Easy git management
	{
	"kdheepak/lazygit.nvim",
	lazy = true,
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- set keybinds for lazygit
	keys = {
		{"<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit"},
	}
	},
  -- Better escaping
  'jdhao/better-escape.vim',
  
  -- Commenting functionality
  'tpope/vim-commentary',
  
  -- Syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        indent = {
          enable = true
        }
      }
    end
  },
  
  -- LSP configuration
  'neovim/nvim-lspconfig',
  
  -- Completion engine and sources
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  
  -- Snippet engine and sources
  'L3MON4D3/LuaSnip',
  'rafamadriz/friendly-snippets',
  'saadparwaiz1/cmp_luasnip',
  
  -- Package manager for LSP servers
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  },
  'williamboman/mason-lspconfig.nvim',
  
  -- File explorer
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = {
      'kyazdani42/nvim-web-devicons'
    },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        hijack_directories = {
          enable = true,
          auto_open = true,
        },
        sort_by = "case_sensitive",
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })
      
      -- Auto open when vim starts with a directory argument
      vim.api.nvim_create_autocmd({ "VimEnter" }, {
        callback = function(data)
          -- Buffer is a directory
          local directory = vim.fn.isdirectory(data.file) == 1
          
          if not directory then
            return
          end
          
          -- Change to the directory
          vim.cmd.cd(data.file)
          
          -- Open the tree
          require("nvim-tree.api").tree.open()
        end
      })
    end
  },
  
  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  
  -- Color scheme
  {
    'morhetz/gruvbox',
    priority = 1000,
    config = function()
      vim.g.gruvbox_italic = 1
      vim.g.gruvbox_contrast_dark = 'hard'
      vim.cmd[[colorscheme gruvbox]]
    end
  },
  
  -- Status line
  {
    'vim-airline/vim-airline',
    dependencies = { 'vim-airline/vim-airline-themes' },
    config = function()
      vim.g.airline_powerline_fonts = 1
      vim.g['airline#extensions#tabline#enabled'] = 1
    end
  },
  'mkitt/tabline.vim',
  
  -- Terminal integration
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require("toggleterm").setup{
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 1,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'single',
        }
      }
    end
  },
  
  -- Tag viewer
  'preservim/tagbar',
  
  -- Dashboard
  'glepnir/dashboard-nvim',
  
  -- Kitty config syntax
  'fladson/vim-kitty',
  
  -- Code formatting
  'sbdchd/neoformat',
  
  -- Falling leaves effect
  {
    'folke/drop.nvim',
    config = function()
      require("drop").setup()
    end
  },
})

-- Set up nvim-cmp for completion
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s", "n" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s", "n" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({}, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?`
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup Mason and LSP
require('mason-lspconfig').setup()

-- LSP configuration with on_attach function
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- Setup installed language servers
local lsp_flags = {
  debounce_text_changes = 150,
}

local lspconfig = require('lspconfig')
for _, server in ipairs(require('mason-lspconfig').get_installed_servers()) do
  lspconfig[server].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  }
end

-- Key mappings
local opts = { noremap = true, silent = false }

-- Diagnostic keymaps
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Split screen to create more windows
vim.keymap.set("n", "<C-v>", "<cmd>vsplit<CR>", opts)
vim.keymap.set("n", "<C-b>", "<cmd>split<CR>", opts)

-- Reformat current buffer
vim.keymap.set("n", "<C-f>", "<cmd>Neoformat<CR>", opts)

-- Resize windows with arrows
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Quit window
vim.keymap.set("n", "<C-q>", "<C-w>q", opts)

-- Navigate buffers
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", opts)

-- Close current buffer
vim.keymap.set("n", "<S-q>", "<cmd>bd<CR>", opts)

-- Open new buffer
vim.keymap.set("n", "<S-n><S-b>", "<cmd>enew<CR>", opts)

-- List existing buffers
vim.keymap.set("n", "<S-s>", "<cmd>ls<CR>", opts)

-- Tab navigation
vim.keymap.set("n", "<A-n>", "<cmd>tabnew<CR>", opts)
vim.keymap.set("n", "<A-h>", "<cmd>tabp<CR>", opts)
vim.keymap.set("n", "<A-l>", "<cmd>tabn<CR>", opts)
vim.keymap.set("n", "<A-q>", "<cmd>tabclose<CR>", opts)

-- Save files
vim.keymap.set("n", "<leader>s", "<cmd>w<CR>", opts)

-- Open NvimTree
vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", opts)

-- Open Tagbar
vim.keymap.set("n", "<leader>t", "<cmd>TagbarToggle<CR>", opts)

-- Telescope mappings
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
vim.keymap.set("n", "<leader>fbu", "<cmd>Telescope buffers<cr>", opts)
vim.keymap.set("n", "<leader>fhe", "<cmd>Telescope help_tags<cr>", opts)

-- DAP keymaps
vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", opts)
vim.keymap.set("n", "<leader>dn", "<cmd>lua require'dap'.step_over()<CR>", opts)
vim.keymap.set("n", "<leader>ds", "<cmd>lua require'dap'.step_into()<CR>", opts)
vim.keymap.set("n", "<leader>dN", "<cmd>lua require'dap'.step_out()<CR>", opts)
vim.keymap.set("n", "<leader>b", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
vim.keymap.set("n", "<leader>B", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
vim.keymap.set("n", "<leader>do", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", opts)
vim.keymap.set("n", "<leader>dR", "<cmd>lua require'dap'.run_last()<CR>", opts)
vim.keymap.set("n", "<leader>dl", "<cmd>lua require('dap.ui.widgets').sidebar(require('dap.ui.widgets').scopes).open()<CR>", opts)

-- Lexima settings
vim.g.lexima_enable_basic_rules = 1
vim.g.lexima_enable_newline_rules = 1
vim.g.lexima_enable_endwise_rules = 1

-- Dashboard settings
vim.g.dashboard_default_executive = 'telescope'

-- Improve vim setting for typescript
vim.g.markdown_fenced_languages = { "ts=typescript" }
