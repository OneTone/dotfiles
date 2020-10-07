# vim: ft=zsh ts=2 sw=2 sts=2 et

WORDCHARS=''

local_wordchars_widget() {
  eval "$2() {
    local WORDCHARS='${3//'/'\"'\"'}'
    zle $1
  }"
  zle -N "$2"
  if [ "$4" ]; then
    bindkey "$4" "$2"
  fi
}

local_wordchars_widget backward-kill-word unix-word-rubout \
$'!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~' '^W'

-._() {
  local_wordchars_widget "$1" "$1-._" '-._' "$2"
}

-._ backward-kill-word '^[^H'
-._ backward-word '^[B'
-._ capitalize-word '^[C'
-._ copy-prev-word '^[M'
-._ down-case-word '^[L'
-._ forward-word '^[F'
-._ insert-last-word '^[_'
-._ kill-word '^[D'
-._ spell-word '^[S'
-._ transpose-words '^[T'
-._ up-case-word '^[U'

unset -f -- -._ local_wordchars_widget

if which sudo-command-line >/dev/null 2>&1; then
  bindkey '^[E' sudo-command-line
  bindkey '^[e' sudo-command-line
fi

bindkey '^U' backward-kill-line
bindkey '^[K' kill-whole-line
bindkey '^[k' kill-whole-line
bindkey '^[l' down-case-word

bindkey '^X^?' where-is
bindkey '^X\^' vi-first-non-blank
bindkey '^X^F' vi-find-next-char
bindkey '^X^T' vi-find-next-char-skip
bindkey '^XF' vi-find-prev-char
bindkey '^XT' vi-find-prev-char-skip
