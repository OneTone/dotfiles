# vim: ft=zsh ts=2 sw=2 sts=2 et

unix-word-rubout() {
  local WORDCHARS=$'!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'
  zle backward-kill-word
}

zle -N unix-word-rubout
bindkey '^W' unix-word-rubout

if type sudo-command-line >/dev/null 2>&1; then
  bindkey '^[e' sudo-command-line
fi

bindkey '^U' backward-kill-line
bindkey '^[k' kill-whole-line
bindkey '^[l' down-case-word
