set nocompatible

if has("syntax")
  syntax on
endif

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'a.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'mbbill/fencview'
Plugin 'mileszs/ack.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-ruby/vim-ruby'

call vundle#end()

if has("autocmd")
  filetype plugin indent on
endif

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

cmap w!! w !sudo tee >/dev/null %

if has("autocmd")
  autocmd! BufEnter * silent! lcd %:p:h
  autocmd! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source %
    autocmd BufWritePost $MYGVIMRC if has("gui_running") | source % | endif
  augroup END
endif
