function! s:jump2lastpos()
  let pos = line("'\"")
  if 1 <= pos && pos <= line('$') && &ft !~# 'commit'
    execute 'normal! g`"'
  endif
endfunction

if has('autocmd')
  autocmd! BufReadPost * call s:jump2lastpos()

  augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source %
    execute 'autocmd BufWritePost' expand('<sfile>:p:h') . '/*.vim' 'source $MYVIMRC'
    autocmd BufWritePost $MYGVIMRC if has('gui_running') | source % | endif
  augroup END
endif
