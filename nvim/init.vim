set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set number
set completeopt=menu,menuone,noselect
set relativenumber
set termguicolors
set cul
set tabstop=2
set shiftwidth=2
set softtabstop=2
set hidden
set autoindent

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

call plug#begin()

" This is a plugin to facilitate using git with vim 
Plug 'https://github.com/tpope/vim-fugitive'

" This plugin is to make it easier to escape vim 
Plug 'https://github.com/jdhao/better-escape.vim'

" This is a plugin to get better commenting of files
Plug 'https://github.com/tpope/vim-commentary'

" This is a code highlighting plugin
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Language server ... config
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" A snipping engine to provide templates for common code 
Plug 'L3MON4D3/LuaSnip' 
Plug 'rafamadriz/friendly-snippets'
Plug 'saadparwaiz1/cmp_luasnip'

" A plugin to match parentheses.
Plug 'cohama/lexima.vim'

" Plugin for easily installing language servers 
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Plugin for seeing a function tree in nvim 
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" A fuzzy finder 
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" This is a color theme plugin 
Plug 'morhetz/gruvbox'

" This is the most famous vim status bar / subject to change 
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'
Plug 'mkitt/tabline.vim'

"A plugin to toggle terminal from inside vim ! 
Plug 'akinsho/toggleterm.nvim' 

" A plugin to display tags on a side tab 
Plug 'preservim/tagbar' 

" A plugin to have a prettier dashboard 
Plug 'glepnir/dashboard-nvim'

" This plug is for syntax highlighting for kitty.conf files 
Plug 'fladson/vim-kitty'

" A plugin for the DAP protocol on nvim
Plug 'mfussenegger/nvim-dap'

" A plugin for formatting multiple file types
Plug 'sbdchd/neoformat'

" Falling leaves on the dashboard
Plug 'folke/drop.nvim'

call plug#end()


" Gruvbox settings 

let g:gruvbox_italic=1

colorscheme gruvbox

autocmd vimenter * ++nested colorscheme gruvbox

let g:gruvbox_contrast_dark='hard'

" Vim airline settings in progress 

let g:airline#extensions#tabline#enabled = 1 
let g:airline_powerline_fonts=1

" Setting fuzzy finder plugin for dashboard-nvim 
let g:dashboard_default_executive='telescope'

" Enable default bracket close rules
let g:lexima_enable_basic_rules = 1
let g:lexima_enable_newline_rules = 1
let g:lexima_enable_endwise_rules = 1

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
		lua require'dap'.list_breakpoints()
        copen
    else
        cclose
    endif
endfunction

" Telescope key mappings 
"
" Setting the leader key 
"
let mapleader = " "

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fbu<cmd>Telescope buffers<cr>
nnoremap <leader>fhe<cmd>Telescope help_tags<cr>


" Lua snippet for plugins 

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
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

-- Load snippets from friendly-snippets

require("luasnip.loaders.from_vscode").lazy_load()

 -- Set up nvim-cmp.

 local has_words_before = function()
		unpack = unpack or table.unpack
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local luasnip = require("luasnip")
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
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
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
    end, { "i", "s","n" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s","n" }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      --{ name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      --{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Adding better mappings for windows, tabs, and buffers , and plugins

 local map = vim.api.nvim_set_keymap

  -- Some key mappings for nvim-cmp and lsp 
  local opts = { noremap = true, silent = false}


-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Split screen to create more windows 
map("n", "<C-v>", "<cmd>vsplit<CR>",opts)
map("n", "<C-b>", "<cmd>split<CR>",opts)

--- Reformat current buffer
map("n","<C-f>","<cmd>Neoformat<CR>",opts)

-- Resize windows with arrows
map("n", "<C-Up>", "<cmd>resize -2<CR>", opts)
map("n", "<C-Down>", "<cmd>resize +2<CR>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)
-- Quit window 
map("n", "<C-q>", "<C-w>q",opts)

-- Navigate buffers
map("n", "<S-l>", "<cmd>bnext<CR>", opts)
map("n", "<S-h>", "<cmd>bprevious<CR>", opts)
-- Close current buffer  
map("n","<S-q>","<cmd>bd<CR>",opts)
-- Open new buffer , clashes with search mapping 
map("n","<S-n><S-b>","<cmd>enew<CR>",opts)
-- List existing buffers 
map("n","<S-s>","<cmd>ls<CR>",opts)

-- Create new tab 
map("n","<A-n>","<cmd>tabnew<CR>",opts)
-- Better navigate tabs 
map("n","<A-h>","<cmd>tabp<CR>",opts)
map("n","<A-l>","<cmd>tabn<CR>",opts)
-- Close current tab 
map("n","<A-q>","<cmd>tabclose<CR>",opts)


-- Save files
map("n","<leader>s","<cmd>w<CR>",opts)
-- Open NvimTree 
map("n","<leader>n","<cmd>NvimTreeToggle<CR>",opts)
-- Open Tagbar
map("n","<leader>t","<cmd>TagbarToggle<CR>",opts)

local widgets = require('dap.ui.widgets')

--  Key mappings for DAP 
map("n", "<leader>dc" ,"<cmd>:lua require'dap'.continue()<CR>",opts)
map("n", "<leader>dn" ,"<cmd>:lua require'dap'.step_over()<CR>",opts)
map("n", "<leader>ds" ,"<cmd>:lua require'dap'.step_into()<CR>",opts)
map("n", "<leader>dN" ,"<cmd>:lua require'dap'.step_out()<CR>",opts)
map("n", "<leader>b" ,"<cmd>:lua require'dap'.toggle_breakpoint()<CR>",opts)
map("n", "<leader>B" ,"<cmd>:lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",opts)
map("n", "<leader>do" ,"<cmd>:lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",opts)
map("n","<leader>dbs" ,"<cmd>:call ToggleQuickFix()<CR>",opts)
map("n", "<leader>dr" ,"<cmd>:lua require'dap'.repl.open()<CR>",opts)
map("n", "<leader>dR" ,"<cmd>:lua require'dap'.run_last()<CR>",opts)
map("n","<leader>dl","<cmd>:lua require('dap.ui.widgets').sidebar(require('dap.ui.widgets').scopes).open()<CR>",opts)



-- Setting dashboard header
local home = os.getenv('HOME')

-- Linking the Header highlight to one of the Gruvbox highlight groups
-- vim.api.nvim_set_hl(0,"DashboardHeader", {link = "GruvboxPurpleBold"})

 -- Setup mason.nvim
local mason  = require('mason').setup()
local mason_lspconfig = require('mason-lspconfig') ; mason_lspconfig.setup()


-- Improve vim setting for typescript
 vim.g.markdown_fenced_languages = {
   "ts=typescript"
 }

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp =  require "cmp_nvim_lsp"

local cap = cmp_nvim_lsp.default_capabilities(capabilities)
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
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

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local lsp = require('lspconfig')

for index,server in ipairs(mason_lspconfig.get_installed_servers()) do 

	lsp[server].setup {
		on_attach = on_attach,
		flags = lsp_flags,
	}
	end

-- Setting up nvim-tree

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- OR setup with some options
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


local function open_nvim_tree(data)

	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	if not directory then 
		return
	end

	-- change to the directory
	vim.cmd.cd(data.file)

	-- open the tree
	require("nvim-tree.api").tree.open()

end

vim.api.nvim_create_autocmd({ "VimEnter" },{ callback = open_nvim_tree })

-- Setting DAP codelldb

local dap = require('dap')

dap.adapters.codelldb = {
	type = 'server',
	port = "${port}",
	executable = {
		command = '/home/deniz/.local/share/nvim/mason/packages/codelldb/codelldb',
		args = {"--port","${port}"},
		}
	}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
	},
}
-- If you want to use this for rust and c, add something like this:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

dap.adapters.node2 = {
  type = 'executable',
  command = '/home/deniz/.local/share/nvim/mason/packages/node-debug2-adapter/node-debug2-adapter',
	args = {}
}
dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

-- Toggleterm setup 

require("toggleterm").setup{
  -- size can be a number or function which is passed the current terminal
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor =1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  direction ='float', 
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'single', --  other options supported by win open
  }
}

-- drop.nvim setup
drop = require("drop")
drop.setup()

EOF
