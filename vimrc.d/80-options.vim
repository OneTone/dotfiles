set background=dark
set hidden
set history=10000
set ignorecase
set infercase
set laststatus=2
set listchars=eol:¶,tab:»\ ,extends:›,precedes:‹,space:·,trail:␣,nbsp:¬
set modeline
set number relativenumber
set pastetoggle=<F12>
set showmatch
set smartcase

if exists('+autochdir')
  set autochdir
endif

if has('cmdline_info')
  set showcmd
endif

if has('extra_search')
  set hlsearch incsearch
endif

if has('linebreak')
  set showbreak=↪
endif

if has('mouse')
  set mouse=a
endif

if has('syntax')
  set cursorcolumn cursorline synmaxcol=0
endif

if has('viminfo')
  set viminfo='10000,<10000,s1024
endif

if has('wildmenu')
  set wildmenu
endif
