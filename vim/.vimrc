for rc in globpath('~/.vim/rc', '*.vim', v:false, v:true)
  execute 'source' rc
endfor
