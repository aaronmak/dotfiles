local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- =======================
-- Plugins
-- =======================

require('plugins')
require("bufferline").setup{
  options = {
    numbers = function(opts)
      return string.format('%s.', opts.id)
    end,
    name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
      return vim.fn.pathshorten(vim.fn.fnamemodify(buf.path, ":~:."))
    end,
    show_buffer_close_icons = false,
    show_close_icon = false,
    max_name_length = 30,
    separator_style = "thick",
  }
}

g['deoplete#enable_at_startup'] = 1

opt.background = 'dark'

require("tokyonight").setup({
  on_highlights = function(hl, c)
    hl.LineNr = {
      fg = "#ff4774"
    }
    hl.LineNrAbove = {
      fg = "#a9b1d6"
    }
    hl.LineNrBelow = {
      fg = "#a9b1d6"
    }
  end,
})
cmd 'colorscheme tokyonight'

require('lualine').setup {
  options = {
    theme = 'tokyonight'
  }
}

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "bash",
    "c",
    "comment",
    "cpp",
    "css",
    "dockerfile",
    "go",
    "json",
    "lua",
    "make",
    "markdown",
    "python",
    "ruby",
    "rust",
    "scss",
    "sql",
    "yaml",
  },
  highlight = {
    enable = true,  -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
  },
}

require('gitsigns').setup {
}

g.instant_username = 'aaronmak'

-- Autocomplete
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
}

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Setup lspconfig
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
require('lspconfig').pylsp.setup {
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
          -- formatter options
          black = { enabled = true },
          autopep8 = { enabled = false },
          yapf = { enabled = false },
          -- linter options
          pyflakes = { enabled = true },
          pycodestyle = { enabled = true },
          -- type checker
          pylsp_mypy = { enabled = true },
          -- auto-completion options
          jedi_completion = { fuzzy = true },
          -- import sorting
          pyls_isort = { enabled = true },
      },
    },
  },
  flags = {
      debounce_text_changes = 200,
  },
}

-- =======================
-- Settings
-- =======================

opt.encoding       = 'utf8'           -- Set utf8 as standard encoding and en_US as the standard language
opt.ffs            = 'unix,dos,mac'   -- Use Unix as the standard file type
opt.hidden         = true             -- Allow buffer change w/o saving
opt.so             = 7                -- Set 7 lines to the cursor - when moving vertically using j/k
opt.cmdheight      = 3                -- Height of the command bar
opt.updatetime     = 300              -- Reduce update time from default of 4000
opt.autoread       = true             -- Auto read when a file is changed from elsewhere
opt.ignorecase     = true             -- Ignore case when searching
opt.smartcase      = true             -- When searching try to be smart about cases
opt.incsearch      = true             -- Makes search act like search in modern browsers
opt.lazyredraw     = true             -- Don't redraw while executing macros (good performance config)
opt.magic          = true             -- For regular expressions turn magic on
opt.showmatch      = true             -- Show matching brackets when text indicator is over them
opt.mat            = 2                -- How many tenths of a second to blink when matching brackets
opt.foldcolumn     = '1'              -- Add a bit extra margin to the left
opt.relativenumber = true             -- Set relative line numbers
opt.number         = true             -- Set line numbers
opt.scrolloff      = 4                -- Keep at least 4 lines below cursor
opt.signcolumn     = 'yes'            -- always show signcolumns
opt.grepprg        = 'rg' --vimgrep   -- Use RipGrep instead of grep
opt.grepformat     = '%f:%l:%c:%m'
opt.swapfile       = false            -- Disable swap files since there's version control

opt.timeoutlen = 500

opt.expandtab = true  -- Use spaces instead of tabs
opt.smarttab  = true   -- Be smart when using tabs

-- 1 tab == 2 spaces
opt.shiftwidth = 2
opt.tabstop    = 2
opt.shiftround = true  -- When at 3 spaces and I hit >>, go to 4, not 5.

-- Linebreak on 500 characters
opt.linebreak   = true
opt.textwidth   = 500
opt.autoindent  = true
opt.smartindent = true
opt.wrap        = true -- Wrap lines

-- Spelling for Markdown and gitcommits
vim.api.nvim_command([[
augroup markdownSpell
  autocmd FileType gitcommit setlocal spell
  autocmd FileType markdown setlocal spell
augroup END
]])

cmd 'syntax enable'
opt.hlsearch      = true
opt.termguicolors = true

-- Disable netrw
g.loaded_netrwPlugin = 1

-- Paste (requires xsel installed)
opt.clipboard = 'unnamedplus'

-- Ignore compiled files
opt.wildignore = '*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store'

opt.completeopt = 'menu,menuone,noselect'

-- Remove trailing whitespaces
cmd 'autocmd BufWritePre * :%s/s+$//e'

-- Do not continue comment on new line
cmd 'autocmd BufNewFile,BufRead * setlocal formatoptions-=cro'

-- =======================
-- Mapping
-- =======================
g.python3_host_prog = "$HOME/.virtualenvs/neovim/bin/python"
g.mapleader = " "

map('', '<C-n><C-h>', ':nohlsearch<CR>')  -- Fast switch off highlights

map('', '<C-s>', '<ESC>:w<CR>') -- Fast saving
map('i', '<C-s>', '<ESC>:w<CR>')
map('n', '<C-s>', ':w<CR>')
map('v', '<C-c>', '+y')  -- Copy to system clipboard

-- Switch buffers with tab
map('n', '<Tab>', ':bnext!<CR>')
map('n', '<S-Tab>', ':bprev!<CR>')

-- Close current buffer
map('n', '<leader>bq', ':bp <bar> bd! #<cr>')

-- Close all buffers
map('n', '<leader>bqa', ':%bdelete <cr>')

-- Close all buffers except current
map('n', '<leader>bqq', ':%bd|e# <cr>')

-- Move up and down by visible lines if current line is wrapped
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- Move to the split in the direction shown, or create a new split
map('n', '<leader><C-h>', ':call WinMove("h")<cr>', {silent = true})
map('n', '<leader><C-j>', ':call WinMove("j")<cr>', {silent = true})
map('n', '<leader><C-k>', ':call WinMove("k")<cr>', {silent = true})
map('n', '<leader><C-l>', ':call WinMove("l")<cr>', {silent = true})
vim.api.nvim_command([[
  function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
      if (match(a:key,'[jk]'))
        wincmd v
      else
        wincmd s
      endif
      exec "wincmd ".a:key
    endif
  endfunction
]])

map('n', '<leader>dcf', ':!rm %<cr>')  -- delete current file
map('n', '<leader>co', ':%y+<cr>')  -- copy all


vim.api.nvim_command([[
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
]])

map('', '<Leader>rf', ':call RenameFile()<cr>')

local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- don't search in the `.git` directory
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
	defaults = {
		-- `hidden = true` is not supported in text grep commands.
		vimgrep_arguments = vimgrep_arguments,
	},
	pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
		live_grep = {
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
	},
})
map('n', '<leader>ff', ':Telescope find_files<cr>')
map('n', '<leader>fg', ':Telescope live_grep<cr>')
map('n', '<leader>fb', ':Telescope buffers<cr>')
map('n', '<leader>fh', ':Telescope help_tags<cr>')

require('smear_cursor').setup({
   cursor_color = '#d3cdc3',
   smear_to_cmd = false,
})

require('leap').create_default_mappings()
