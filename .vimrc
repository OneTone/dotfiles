function! s:load_all(dir)
  for rc in globpath(a:dir, '*.vim', v:false, v:true)
    execute 'source' rc
  endfor
endfunction

function! s:find_vimrc_dir()
  for rtp in split(&runtimepath, ',')
    for name in ['vimrc.d', 'vimrc.d.lnk']
      let dir = resolve(rtp .. '/' .. name)
      if isdirectory(dir)
        return dir
      endif
    endfor
  endfor
  return ''
endfunction

let s:vimrc_dir = s:find_vimrc_dir()
if !empty(s:vimrc_dir)
  call s:load_all(s:vimrc_dir)
endif
