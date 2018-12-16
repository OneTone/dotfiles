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
