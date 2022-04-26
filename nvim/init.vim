set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set number
set completeopt=menu,menuone,noselect
set relativenumber
set termguicolors
set cul
set tabstop=4
set shiftwidth=4
set softtabstop=4
set hidden

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

" For luasnip users.
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Plugin for easily installing language servers 
Plug 'williamboman/nvim-lsp-installer'

" Plugin for seeing a function tree in nvim 
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" A fuzzy finder 
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', {'tag': 'nvim-0.6'}

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

" This plugin is for editing latex files
Plug 'lervag/vimtex'

" A plugin for the DAP protocol on nvim
Plug 'mfussenegger/nvim-dap'

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
let g:dashboard_default_executive='telescope.nvim'
" " Setting dashboard header
let g:dashboard_custom_header=['  ___ _   ___     _____ __  __  ____ ___ ____  _     _____', 
\' |_ _| \ | \ \   / |_ _|  \/  |/ ___|_ _| __ )| |   | ____|',
\'  | ||  \| |\ \ / / | || |\/| | |    | ||  _ \| |   |  _|',  
\'  | || |\  | \ V /  | || |  | | |___ | || |_) | |___| |___', 
\' |___|_| \_|  \_/  |___|_|  |_|\____|___|____/|_____|_____|']
                                                           
" " Setting custom telescope keyboards for dashboard 
" let g:dashboard_custom_shortcut={
" \ 'last_session'       : 'SPC s l',
" \ 'find_history'       : 'SPC f h',
" \ 'find_file'          : 'SPC f f',
" \ 'new_file'           : 'SPC c n',
" \ 'change_colorscheme' : 'SPC t c',
" \ 'find_word'          : 'SPC f a',
" \ 'book_marks'         : 'SPC f b',
" \}

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

" Key mappings for DAP 

nnoremap <silent> <leader>dc :lua require'dap'.continue()<CR>
nnoremap <silent> <leader>dn :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>ds :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>dN :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>do :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent><leader>dl :call ToggleQuickFix()<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dR :lua require'dap'.run_last()<CR>


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

-- Setup nvim-cmp.
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
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
 ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
         behavior = cmp.ConfirmBehavior.Replace,
         select = true,
      }),
      ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
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
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it. 
    }, {
      { name = 'buffer' },
    })
  })

    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })

  -- Some key mappings for nvim-cmp and lsp 
  local opts = { noremap = true, silent = true}
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "go", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>p", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

-- Adding better mappings for windows, tabs, and buffers 

local map = vim.api.nvim_set_keymap

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Split screen to create more windows 
map("n", "<C-v>", "<cmd>vsplit<CR>",opts)
map("n", "<C-b>", "<cmd>split<CR>",opts)

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
-- map("n","<S-n>","<cmd>enew<CR>",opts)
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


  -- Adding a handler for installing language servers 

local lsp_installer = require "nvim-lsp-installer"
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp =  require "cmp_nvim_lsp"

local cap = cmp_nvim_lsp.update_capabilities(capabilities)

lsp_installer.on_server_ready(function(server)
  local opts = server:get_default_options()
  opts.capabilities = cap
  server:setup(opts)
end)

-- Setting up nvim-tree
require 'nvim-tree'.setup()

-- Setting up DAP for cpp and c 

local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html

    runInTerminal = false,

    -- 💀
    -- If you use `runInTerminal = true` and resize the terminal window,
    -- lldb-vscode will receive a `SIGWINCH` signal which can cause problems
    -- To avoid that uncomment the following option
    -- See https://github.com/mfussenegger/nvim-dap/issues/236#issuecomment-1066306073
    postRunCommands = {'process handle -p true -s false -n false SIGWINCH'}
  },
}


-- If you want to use this for rust and c, add something like this:
dap.configurations.c = dap.configurations.cpp

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

EOF


