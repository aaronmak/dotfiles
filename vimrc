" =======================
" Plugins (vim-plug)
" =======================

" Installs vim plug if does not exist
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
" Convenience
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" Improve display
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'                  " For cool colors
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'
" Testing
Plug 'janko/vim-test'
" Rails
Plug 'tpope/vim-rails'
Plug 'thoughtbot/vim-rspec'
call plug#end()

" =======================
" Mapping
" =======================
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

map <C-h> :nohl<cr>                               " Fast switch off highlights
" Note that remapping C-s requires flow control to be disabled
" (e.g. in .bashrc or .zshrc)
map <C-s> <esc>:w<CR>                             " Fast saving
imap <C-s> <esc>:w<CR>
nmap <C-s> :w<cr>
nmap <leader>vi :tabedit ~/.vimrc<cr>             " Edit your vimrc in a new tab
nmap <leader>so :source $MYVIMRC<cr>              " Source (reload) your vimrc

" Git
nmap <leader>g :G<cr>
nmap <leader>ga :Git commit --amend --reuse-message=HEAD<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gpf :Git push --force-with-lease<cr>

" Move up and down by visible lines if current line is wrapped
nmap j gj
nmap k gk

" =======================
" Settings
" =======================
set nocompatible      " Disable backward compatibility with vi
set encoding=utf8     " Set utf8 as standard encoding and en_US as the standard language
set ffs=unix,dos,mac  " Use Unix as the standard file type
set hidden            " Allow buffer change w/o saving

set so=7              " Set 7 lines to the cursor - when moving vertically using j/k
set cmdheight=3       " Height of the command bar

set autoread          " Auto read when a file is changed from elsewhere
set ignorecase        " Ignore case when searching
set smartcase         " When searching try to be smart about cases
set incsearch         " Makes search act like search in modern browsers
set lazyredraw        " Don't redraw while executing macros (good performance config)
set magic             " For regular expressions turn magic on
set showmatch         " Show matching brackets when text indicator is over them
set mat=2             " How many tenths of a second to blink when matching brackets
set foldcolumn=1      " Add a bit extra margin to the left
set relativenumber    " Set relative line numbers
set number            " Set line numbers
set scrolloff=4       " Keep at least 4 lines below cursor

set grepprg=ag        " Use Silver Searcher instead of grep

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

set expandtab  " Use spaces instead of tabs
set smarttab   " Be smart when using tabs
" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

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
map <Leader>n :call RenameFile()<cr>

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

" vim-test
let test#neovim#term_position = "vertical botright"
let test#strategy = "neovim"

" Make CtrlP use ag for listing the files. Way faster and no useless files.
let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
let g:ctrlp_use_caching = 0

" Set color and theme
colorscheme gruvbox
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1
