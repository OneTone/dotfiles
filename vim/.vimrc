set nocompatible

if has("syntax")
  syntax on
endif

let mapleader = ' '

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'Valloric/YouCompleteMe'
Plugin 'Yggdroot/LeaderF'
Plugin 'a.vim'
Plugin 'chrisbra/csv.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'kergoth/vim-bitbake'
Plugin 'luochen1990/rainbow'
Plugin 'majutsushi/tagbar'
Plugin 'mbbill/fencview'
Plugin 'mileszs/ack.vim'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'pangloss/vim-javascript'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'sk1418/QFGrep'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-ruby/vim-ruby'

call vundle#end()

if has("autocmd")
  filetype plugin indent on
endif

if has("gui_running")
  colorscheme solarized
else
  colorscheme Monokai
endif

set autochdir
set background=dark
set cursorcolumn
set cursorline
set hidden
set history=10000
set hlsearch
set ignorecase
set incsearch
set infercase
set laststatus=2
set listchars=eol:¶,tab:»\ ,extends:›,precedes:‹,space:·,trail:␣,nbsp:¬
set mouse=a
set number relativenumber
set pastetoggle=<F12>
set showbreak=↪\ 
set showcmd
set showmatch
set smartcase
set synmaxcol=0
set viminfo='10000,<10000,s1024
set wildmenu

let g:airline_powerline_fonts = 1
let g:ctrlp_max_files = 0
let g:rainbow_active = 1

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
let g:ack_mappings = {
  \ 'i': '<C-W><CR><C-W>K',
  \ 'gi': '<C-W><CR><C-W>K<C-W>b',
  \ 's': '<C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t',
  \ 'gs': '<C-W><CR><C-W>H<C-W>b<C-W>J',
  \ '?': '?',
  \ 'h': 'h',
  \ 'H': 'H',
  \ 'v': 'v',
  \ 'gv': 'gv',
\}

cmap w!! w !sudo tee >/dev/null %

if has("autocmd")
  autocmd! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source %
    autocmd BufWritePost $MYGVIMRC if has("gui_running") | source % | endif
  augroup END
endif
