" =======================
" Plugins (vim-plug)
" =======================

call plug#begin('~/.local/share/nvim/plugged')
" Convenience
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'christoomey/vim-tmux-navigator'
" Improve display
Plug 'blueyed/vim-diminactive'
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'                  " For cool colors
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'
" Autocomplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'deoplete-plugins/deoplete-jedi'
" All languages syntax
Plug 'sheerun/vim-polyglot'
" Testing
Plug 'janko/vim-test'
" Linting
Plug 'dense-analysis/ale'
" Rails
Plug 'tpope/vim-rails'
Plug 'thoughtbot/vim-rspec'
" Django
Plug 'tweekmonster/django-plus.vim'
" Python
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'psf/black'
" GraphQL
Plug 'jparise/vim-graphql'
" Haskell
Plug 'neovimhaskell/haskell-vim'
" Flutter
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
" Formatting with editor config
Plug 'editorconfig/editorconfig-vim'
" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" tmux
Plug 'tmux-plugins/vim-tmux-focus-events'
call plug#end()

" =======================
" Mapping
" =======================
let g:deoplete#enable_at_startup = 1
let g:python3_host_prog = expand('~/.pyenv/versions/neovim3/bin/python')
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

map <C-n><C-h> :nohl<cr>                          " Fast switch off highlights
" Note that remapping C-s requires flow control to be disabled
" (e.g. in .bashrc or .zshrc)
map <C-s> <esc>:w<CR>                             " Fast saving
imap <C-s> <esc>:w<CR>
nmap <C-s> :w<cr>

" Switch buffers with tab
nnoremap <Tab> :bnext!<CR>
nnoremap <S-Tab> :bprev!<CR>

"close current buffer
nnoremap <leader>bq :bp <bar> bd! #<cr>

"close all open buffers
nnoremap <leader>bqa :%bd!<cr>

nmap <leader>vi :tabedit ~/.vimrc<cr>             " Edit your vimrc in a new tab
nmap <leader>so :source $MYVIMRC<cr>              " Source (reload) your vimrc

" Git
nmap <leader>g :G<cr>
nmap <leader>ga :Git commit --amend --reuse-message=HEAD<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gpf :Git push --force-with-lease<cr>

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Fzf
nmap <leader>rg :Rg<Space>

" Move up and down by visible lines if current line is wrapped
nmap j gj
nmap k gk

" move to the split in the direction shown, or create a new split
nnoremap <silent> <leader><C-h> :call WinMove('h')<cr>
nnoremap <silent> <leader><C-j> :call WinMove('j')<cr>
nnoremap <silent> <leader><C-k> :call WinMove('k')<cr>
nnoremap <silent> <leader><C-l> :call WinMove('l')<cr>

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

" Delete current file
nmap <leader>dcf :!rm %<cr>

" Copy all
nmap <leader>co :%y+<cr>

" =======================
" Settings
" =======================
set nocompatible            " Disable backward compatibility with vi
set encoding=utf8           " Set utf8 as standard encoding and en_US as the standard language
set ffs=unix,dos,mac        " Use Unix as the standard file type
set hidden                  " Allow buffer change w/o saving
set so=7                    " Set 7 lines to the cursor - when moving vertically using j/k
set cmdheight=3             " Height of the command bar
set updatetime=300          " Reduce update time from default of 4000
set autoread                " Auto read when a file is changed from elsewhere
set ignorecase              " Ignore case when searching
set smartcase               " When searching try to be smart about cases
set incsearch               " Makes search act like search in modern browsers
set lazyredraw              " Don't redraw while executing macros (good performance config)
set magic                   " For regular expressions turn magic on
set showmatch               " Show matching brackets when text indicator is over them
set mat=2                   " How many tenths of a second to blink when matching brackets
set foldcolumn=1            " Add a bit extra margin to the left
set relativenumber          " Set relative line numbers
set number                  " Set line numbers
set scrolloff=4             " Keep at least 4 lines below cursor
set signcolumn=yes          " always show signcolumns
set grepprg=rg\ --vimgrep   " Use RipGrep instead of grep
set grepformat^=%f:%l:%c:%m
set completeopt-=preview    " Disable preview

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowritebackup
set nowb
set noswapfile

set expandtab  " Use spaces instead of tabs
set smarttab   " Be smart when using tabs
" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.

" Linebreak on 500 characters
set lbr
set tw=500
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Spelling for Markdown and gitcommits
augroup markdownSpell
  autocmd FileType gitcommit setlocal spell
  autocmd FileType markdown setlocal spell
augroup END

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  set termguicolors
endif

" Bind `q` to close the buffer for help files
autocmd Filetype help nnoremap <buffer> q :q<CR>

" Per default, netrw leaves unmodified buffers open. This autocommand
" deletes netrw's buffer once it's hidden (using ':q', for example)
autocmd FileType netrw setl bufhidden=delete

" =======================
" Text
" =======================

" By default, vim thinks .md is Modula-2.
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Don't automatically continue comments after newline
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

" Delete trailing white space on save, useful for Python and CoffeeScript
func! DeleteTrailingWS()
exe "normal mz"
%s/\s\+$//ge
exe "normal `z"
endfunc
autocmd BufWrite *.hs :call DeleteTrailingWS()
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

autocmd BufWritePre * :%s/\s\+$//e   " Remove trailing whitespaces

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <Leader>rf :call RenameFile()<cr>

" Copy to system clipboard
vnoremap <C-c> "+y

" Paste (requires xsel installed)
set clipboard=unnamedplus

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
set wildignore+=.git\*,.hg\*,.svn\*
endif

" =======================
" Plugins Configuration
" =======================

" haskell-vim
filetype plugin indent on

" vim-test
let test#neovim#term_position = "vertical botright"
let test#strategy = "neovim"

" Make CtrlP use rg for listing the files. Way faster and no useless files.
let g:ctrlp_user_command = 'rg %s --hidden --files --color=never --glob ""'
let g:ctrlp_use_caching = 0
let g:ctrlp_switch_buffer = 0

" Set color and theme
colorscheme gruvbox
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1

" Ale linting
let g:ale_python_auto_pipenv = 1
let g:ale_linters = {'dart': ['language_server']}
let g:ale_fixers = {'dart': ['dartfmt']}
let g:ale_fix_on_save = 1

" diminactive
let g:diminactive_enable_focus = 1

" Run Black on save
autocmd BufWritePre *.py execute ':Black'
