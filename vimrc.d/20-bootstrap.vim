function! s:download(url, dir)
  let url = shellescape(a:url)
  if executable('curl')
    let file = shellescape(a:dir .. '/' .. fnamemodify(a:url, ':t'))
    execute 'silent !curl --create-dirs -fLso' file url
  elseif executable('wget')
    let dir = shellescape(a:dir)
    execute 'silent !wget -qP' dir url
  else
    echoerr 'unable to download' url
  endif
endfunction

function! s:find_plug_vim()
  let fallback = ''
  for rtp in split(&runtimepath, ',')
    let file = rtp .. '/autoload/plug.vim'
    if empty(fallback)
      let fallback = file
    endif
    if filereadable(file)
      return file
    endif
  endfor
  return fallback
endfunction

function! s:ensure_vimplug()
  let url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  let file = s:find_plug_vim()
  if !empty(file) && !filereadable(file)
    call s:download(url, fnamemodify(file, ':h'))
    if has('autocmd')
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
  endif
endfunction

call s:ensure_vimplug()
