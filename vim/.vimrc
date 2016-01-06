set nocompatible
syntax on
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'a.vim'
Plugin 'bling/vim-airline'
Plugin 'majutsushi/tagbar'
Plugin 'mbbill/fencview'
Plugin 'mileszs/ack.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-ruby/vim-ruby'

call vundle#end()
filetype plugin indent on

set showcmd
set showmatch
set ignorecase
set smartcase
set mouse=a
set wildmenu
set hlsearch
set laststatus=2

let g:airline_powerline_fonts = 1
let g:ctrlp_max_files = 0

autocmd BufEnter * silent! lcd %:p:h
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

cmap w!! w !sudo tee >/dev/null %
