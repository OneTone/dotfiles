function! s:load_all(dir)
  for rc in globpath(a:dir, '*.vim', v:false, v:true)
    execute 'source' rc
  endfor
endfunction

call s:load_all('~/.vim/rc')
